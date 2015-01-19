acceptLanguage = require "accept-language"
Remarkable = require "remarkable"
hljs = require "highlight.js"
_ = require "lodash"
xss = require "xss"

# @Markdown render sync based on Remarkable
markdown = new Remarkable "full",
	langPrefix: "language-"
	typographer: true
	xhtmlOut: false
	linkify: true
	breaks: true
	html: true
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

module.exports = 

	markdown: markdown

	getLocaleGlobal: (cookieLocale, headerLanguage) ->
		type = require("#{process.cwd()}/api/services/Utils.coffee").type
		acceptLanguage.default "ru-RU"

		if type(cookieLocale) is "string" and cookieLocale in ["en", "ru", "pl"]
			cookieLocale
		else
			acceptLanguage.parse(headerLanguage)[0].language


	# @Async rendered post content using markdown
	renderPost: (post, cb) ->		
		renderedContent = markdown.render(post.content)

		contentPlainText = xss "#{renderedContent.substr(0, 250)}...",
			stripIgnoreTagBody: ['script']
			stripIgnoreTag: true
			whiteList: []
		
		post = _.merge post, content: contentPlainText

		cb null, post
		return