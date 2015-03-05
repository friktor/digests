Promise = require "bluebird"
RSS = require "rss"
xss = require "xss"

postCommon = require "../post/common.coffee"
notExists = require "../errors/notExists.coffee"

module.exports = (req, res) ->

	locale = req.param "locale" # locale param

	# Switch validate for and set locale.
	switch true
		when /(^ru$|^en$|^pl$)/.test(locale)
			locale = locale
		else
			locale = postCommon.getLocaleGlobal req.cookies.locale, req.headers["accept-language"]	

	Post.find().sort("createdAt desc").limit(25).then((posts) ->
		Feeds = new RSS
			title: sails.__ 
				phrase: "Latest posts on Digests.me"
				locale: locale

			description: sails.__
				phrase: "main rss feed with all the latest posts"
				locale: locale
				
			feed_url: "http://digests.me/rss/newest/"+locale+".xml"
			webMaster: "Anton Shramko <dev@digests.me>"
			site_url: "http://digests.me/"

		posts.forEach (post, index) ->
			content = xss postCommon.markdown.render(post.content), 
				stripIgnoreTagBody: ['script']				
				stripIgnoreTag: true 
				whiteList: []

			Feeds.item
				url: "http://digests.me/details/"+post.numericId
				description: content.substr 0, 300
				date: post.createdAt
				title: post.title
			return

		Xml = Feeds.xml()
		res.send Xml
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)