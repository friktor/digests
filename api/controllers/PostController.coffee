 # PostController
 #
 # @description :: Server-side logic for managing posts
 # @help        :: See http://links.sailsjs.org/docs/controllers

require "coffee-script/register"

# Dependencies
Remarkable = require "remarkable"
hljs = require "highlight.js"
Promise = require "bluebird"
moment = require "moment"
xss = require "xss"
fs = require "fs"

module.exports = 

	# See "api/controllers/post/create.coffee"
	create: require "./post/create.coffee"

	# See "api/controllers/post/popular.coffee"
	popular: require "./post/popular.coffee"

	# See "api/controllers/post/details.coffee"
	details: require "./post/details.coffee"


	###
	@action: list latest posts
	@description: list all posts with json response for ajax
	@params: {page | default: 1}, {locale | default: "ru"}
	@dependencies: xss, async, i18n
	###

	
	list: (req, res) ->
		locale = req.param "locale"
		page = req.param "page", 1

		RenderProtectAndCut = (obj, callback) ->
			content = markdown.render(obj.content)

			callback null, _.merge(obj, {
				content: require("xss")(content.substr(0, 250)+"...", {
					whiteList: [], 
					stripIgnoreTag: true, 
					stripIgnoreTagBody: ['script']
				}),
			})

		where = {}
		where.locale = locale if locale

		Post.find()

		.sort("createdAt desc")

		.where(where)

		.paginate({
			page: page,
			limit: 15,
		})

		.then((posts) ->
			if posts[0]
				if req.param("render", false) is "true"
					async.map posts, RenderProtectAndCut, (err, posts) ->
						res.json posts
				else
					res.view
						title: "#{req.__("Newest Posts")} ● #{sails.config.application.name} ● #{page} #{req.__("page")}"
						posts: posts
						page: page	
			else
		  	throw new Error "Posts not found in this page"
		)

		.caught (error) ->
			#sails.log.error error
			res.notFound()



	###
	@action: posts by author
	@description: list posts by author from username
	@params: {page | default: 1}, {username | required}
	@dependencies: defaults {{none}}
	###


	by_author: (req, res) ->
		username = req.param "username"
		page = req.param "page", 1

		User.findOneByUsername(username).populate("avatarImg")

		.then((user) ->
			if user
				User = user
				
				Posts = Post.find()
					.sort("createdAt desc")
					.where(author: user.id)
					.paginate(
						page: page
						limit: 15 
					)
					.then (posts) -> posts

				countSubscribers = Subscribe.count({from: "Author", by: user.id}).then (count) -> count

				[User, Posts, countSubscribers]
			else
				throw new Error "User does not exists"
		)

		.spread((user, posts, countSubscribers) ->
			if posts[0]
				res.view
					title: "#{req.__("Posts by %s", user.username)} ● #{sails.config.application.name} ● #{page} #{req.__("page")}"
					countSubscribers: countSubscribers			
					posts: posts	
					user: user
			else
				throw new Error "posts empty in this page"	
		)

		.caught (error) ->
			sails.log.error if error
			res.notFound()

	update: (req, res) ->
		id = req.param "id"

		params = 
			# Main param
			headerImg: req.param "header_img"
			author  : req.param "author"
			content : req.param "content"
			locale  : req.param "locale"
			title   : req.param "title"
			hab     : req.param "hab"
			tags    : req.param "tags" 
			
			# Locale object && parse Draft boolean
			draft   : req.param "draft"

		Post.findOneById(id)

		.then((post) ->
			if !post then res.forbidden() else
				Post.update(post.id, params)
		)

		.then((updated) -> updated[0])

		.then((post) ->
			res.json
				success: true
				post: post
		)

		.caught((error) -> 
			sails.log.error error
			res.serverError()
		)
		

	_config: 
		shortcuts: false 
		actions: false 
		rest: false
