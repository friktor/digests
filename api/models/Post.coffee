 # Post.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs		  :: http://sailsjs.org/#!documentation/models

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
	$protect_title = xss($Post.title, XSS_opt.plainText);
	$Post.title = $protect_title;

	# # XSS protect html content
	# $protect_sinopsis = xss($Post.sinopsis, XSS_opt.HtmlProtect);
	# $protect_content = xss($Post.content, XSS_opt.HtmlProtect);

	# # Replace Data
	# $Post.sinopsis = $protect_sinopsis;
	# $Post.content = $protect_content;

	# If title is empty after XSS replace - throw new error
	return next(new Error("title is empty after xss protect")) if $protect_title is "" or $protect_title is null

	next()

module.exports = Post;