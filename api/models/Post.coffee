 # Post.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs		  :: http://sailsjs.org/#!documentation/models

randomString = require "random-string"
moment = require "moment"
xss = require "xss"

Post =

	attributes: 

		headerImg: 
			type: "string"
			required: false
		
		title:
			type: "string"
			required: true
			maxLength: 150
		
		content: 
			type: "string"
			required: true
		
		hab: 
			type: "string" # uuid request hab
			required: true

		starred:
			type: "array"
			defaultsTo: [] # uuid stared this ["uuid_1", etc...]

		draft: 
			type: "boolean"
			defaultsTo: false

		locale: 
			type: "string"
			defaultsTo: "ru"

		author: 
			type: "string",
			required: true

		tags: 
			type: "string"
			defaultsTo: ""

		markLang:
			type: "string"
			defaultsTo: "markdown"

		showed:
			type: "integer"
			defaultsTo: 0


Post.beforeCreate = ($Post, next) ->

	# XSS protect title - to plain text
	$protect_title = xss $Post.title, 
		stripIgnoreTagBody: ["script"]
		stripIgnoreTag: true
		whiteList: []
	
	$Post.title = $protect_title;

	$Post.numericId = moment().format("DD.MM.YY")+"-"+randomString(
		special: false
		letters: false
		numeric: true
		length: 10
	)

	# If title is empty after XSS replace - throw new error
	return next(new Error("title is empty after xss protect")) if $protect_title is "" or $protect_title is null

	next()

module.exports = Post;