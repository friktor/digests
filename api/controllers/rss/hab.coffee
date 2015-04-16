Promise = require "bluebird"
RSS = require "rss"
xss = require "xss"

postCommon = require "../post/common.coffee"
notExists = require "../errors/notExists.coffee"

module.exports = (req, res) ->

	locale = req.param "locale" # locale param
	name = req.param "name" #hab translit name	
	
	# Switch validate for and set locale.
	switch true
		when /(^ru$|^en$|^pl$)/.test(locale)
			locale = locale
		else
			locale = postCommon.getLocaleGlobal req.cookies.locale, req.headers["accept-language"]

	Hab.findOne(translitName: name).then((hab) ->
		if !hab then throw new notExists() else
			posts = Post.find(hab: {contains: hab.id}, locale: locale).sort("createdAt desc").limit(25).then (posts) -> posts
			[hab, posts]
	)

	.spread((hab, posts) ->
		
		# Set description by locale
		hab.description = try
			_.find(hab.description, "locale": locale).desc
		catch e
			"personal hab feed"

		# Set name by locale
		hab.name = try
			_.find(hab.name, "locale": locale).name
		catch e
			hab.translitName
		
		# New instanse feed
		Feeds = new RSS
			feed_url: "http://digests.me/rss/hab/"+hab.translitName+"/"+locale+".xml"
			webMaster: "Anton Shramko <dev@digests.me>"
			description: hab.description
			site_url: "http://digests.me/"			
			language: locale
			title: hab.name

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

	.caught(notExists, (e) ->
		res.notFound()
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)