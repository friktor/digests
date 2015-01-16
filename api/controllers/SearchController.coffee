translit = require 'transliteration'

# Dependencies
Remarkable = require "remarkable"
Promise = require "bluebird"
moment = require "moment"
fs = require "fs"

# new instance parser from class
markdown = new Remarkable
	langPrefix: "language-",
	typographer: false,
	xhtmlOut: false,
	linkify: true,
	breaks: true,
	html: false,
	quotes: '“”‘’'

RenderProtectAndCut = (obj, callback) ->
	content = markdown.render(obj.content)

	callback null, _.merge(obj, {
		content: require("xss")(content.substr(0, 250)+"...", {
			whiteList: [], 
			stripIgnoreTag: true, 
			stripIgnoreTagBody: ['script']
		}),
	})

module.exports = 
	
	index: (req, res) ->
		options = JSON.parse(req.param "options", "{}")
		json = req.param "json"
		query = req.param "q"

		if query and query.replace(/^\s+|\s+$/g, "") isnt ""
			tw_query = query.replace /^\s+|\s+$/g, ""

			Post.find().sort("createdAt desc")

			.where(
				title: 
					"contains": tw_query
			)

			.paginate(
				page: req.param "page", 1
				limit: 15
			)

			.then((findedPosts) ->
				if json is "true"
					async.map(findedPosts, RenderProtectAndCut, (err, posts) ->
						res.json posts
					)
				else
					res.view
						title: req.__ "Search on Site"
						posts: findedPosts	
			)
		
		else
			res.view
				title: req.__ "Search on Site"
		return

	_config: 
		# shortcuts: false 
		# actions: false 
		# rest: false
		jsonp: true