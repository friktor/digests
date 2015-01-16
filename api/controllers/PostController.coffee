 # PostController
 #
 # @description :: Server-side logic for managing posts
 # @help        :: See http://links.sailsjs.org/docs/controllers

# Dependencies
Remarkable = require "remarkable"
Plugin = require "remarkable-regexp"
Promise = require "bluebird"
moment = require "moment"
fs = require "fs"
xss = require "xss"
hljs = require "highlight.js"

hashTags = Plugin /#(\w+)/, (match, utils) ->
	searchUrl = "#{sails.config.application.url}/search?ht=true&q=#{match[1]}"
	return "<a href=\"#{utils.escape(searchUrl)}\">#{utils.escape(match[0])}</a>"
	

# new instance parser from class
markdown = new Remarkable("full",
	langPrefix: "language-",
	typographer: true,
	xhtmlOut: false,
	linkify: true,
	breaks: true,
	html: true,
	quotes: '“”‘’'
	highlight: (str, lang) ->
		if lang and hljs.getLanguage(lang)
			try
				return hljs.highlight(lang, str).value
			catch e
		
		try
			return hljs.highlightAuto(str).value
		catch e
		
		return ""
		
			
).use(hashTags)

module.exports = 

	###
	@action: create
	@description: create new post in DB
	@params:	{content: contentMarkdown}, 
						{locale: language_posts}, 
						{headingImage: link},
						{author: author_id}, 
						{title: title}, 
						{hab: hab_id}

	@dependencies: defaults {{none}}
	###


	create: (req, res) ->
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

		postEvent.create(params)

			.then((post)->
				res.json {post: post, complete: true}
			)
			.fail((error) ->
				res.json error: error
			)
		;


	###
	@action: list latest populars posts
	@description: list all posts with json response for ajax
	@params: {page | default: 1}, {locale | default: "ru"}
	@dependencies: xss, async, i18n
	###

	popular: (req, res) ->
		locale = req.param "locale", null
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

		where = 
			createdAt:
				">": moment().subtract(7, "d").toDate()

		where.locale = locale if locale

		Post.find()
		
		.where(where)

		.sort({
			# createdAt: "desc",
			showed: "desc",
		})

		.paginate({
			page: page,
			limit: 15,
		})

		.then((posts) ->
			if posts[0]
				if req.param("render", false) is "true"
					async.map(posts, RenderProtectAndCut, (err, posts) ->
						res.json posts
					)
				else
					res.view
						title: "#{req.__("Popular Today")} ● #{sails.config.application.name} ● #{page} #{req.__("page")}"
						posts: posts
						page: page	
			else
		  	throw new Error "Posts not found in this page"
		)

		.caught (error) ->
			#sails.log.error error
			res.notFound()



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



	###
	@action: details view post
	@description: details show post - with render markdown, with comments
	@params: {id | post_id, required}
	@dependencies: remarkable(markdown parser)
	###

	details: (req, res) ->
		id = req.param "id"

		if !id 
			res.notFound()
		else
			Post.findOneById(id)

			.then((post) ->
				if post
					### Showes for user ###
					if !post.showed
						post.showed = 0

					# increment showed
					post.showed +=1
					post.save()

					# Hab - hab info
					hab = Hab.findOneById(post.hab).then (hab) -> hab

					# Author - author this post info
					author = User.findOneById(post.author).populate("avatarImg").then (user) -> user

					# Comments this post
					comments_Populated = ->
						new Promise (resolve, reject) ->
							Comment.find()
							.sort("createdAt desc")
							.where(post: post.id)
							
							.exec (error, comments) -> 
	
								populateAuthor = (comment, callback) ->
									User.findOne()
									.where(id: comment.author)
	
									.populate("avatarImg")
									.populate("headingImg")
									
									.exec (error, user) ->
	
										populated = _.merge(comment, author: user.toJSON() )
										# sails.log populated 
	
										callback error, populated
										return
									return
	
								async.map comments, populateAuthor, (error, PopulatedComments) ->
									if error
										reject error
									else
										# sails.log PopulatedComments
										resolve PopulatedComments
									return
								return
							return

					comments = comments_Populated().then (comments) -> comments			

					# return post, hab, author info from promise
					[post, hab, author, comments]

				else
					throw new Error "Post not found"
			)

			# Promise
			.spread((post, hab, author, comments) ->
				content = xss markdown.render(post.content), 
					whiteList: XSS_opt.whiteList
					stripIgnoreTag: false

				post.content = content

				# view send details
				res.view
					title: "#{post.title} ● #{sails.config.application.name}"
					tags: post.tags.split /\s*,\s*/
					comments: comments
					author: author
					post: post
					hab: hab

					keywords_: post.tags
					description_: "#{(xss(post.content, XSS_opt.plainText)).substr(0, 250)}..."
			)

			.catch (error) ->
				sails.log.error error
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
