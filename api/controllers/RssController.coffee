Remarkable = require "remarkable"
moment = require "moment"
RSS = require "rss"

i18n = require "i18n"

markdown = new Remarkable
	langPrefix: "language-",
	typographer: false,
	xhtmlOut: false,
	linkify: true,
	breaks: true,
	html: false,
	quotes: '“”‘’'

toPlainText = (text) ->
	text = markdown.render(text)
	
	text = require("xss")(text, {
		whiteList: [], 
		stripIgnoreTag: true, 
		stripIgnoreTagBody: ['script']
	})

	return text;


module.exports = 

	newest: (req, res) ->
		locale = req.param "locale", "ru"

		Post.find()
			.sort("createdAt desc")
			.where(locale: locale)

			.limit(20)

			.then((posts) ->
				Constructor =
					description: sails.__ {phrase: "RSS Feed «New» in the World Digest", locale: locale}
					title: sails.__ {phrase: "Newest posts. World Digests", locale: locale}
					feed_url: "http://localhost:9000/rss/newest.xml"
					site_url: "http://localhost:9000/"
					webMaster: "Anton Shramko"
					language: locale

				Feed = new RSS(Constructor)
	
				_.each posts, (post) ->
					description = toPlainText post.content.substr(0, 250)+"..."
	
					Feed.item
						url: "http://localhost:9000/details/#{post.id}"
						description: description
						date: post.createdAt
						title: post.title
						author: ""
	
				setTimeout(->
					xml = Feed.xml()
					res.send xml
				, 0)			
			)

			.caught (error) ->
				#sails.log.error error
				res.serverError()

	byauthor: (req, res) ->
		username = req.param "username"
		locale = req.param "locale", "ru"

		i18n.configure sails.config.i18n # configure i18n
		i18n.setLocale locale # set locale

		User.findOneByUsername(username)

		.then((user) ->
			if user
				Posts = Post.find()
					.where(author: user.id)
					.sort("createdAt desc")
					.limit(20)
					.then (posts) -> posts
				
				[user, Posts]
			else
				throw new Error "User does not exists"
		)

		.spread((user, posts) ->
			Constructor = 
				description: i18n.__ "Personal RSS with posts by %s %s", user.firstname, user.lastname
				feed_url: "http://localhost:9000/rss/author/#{user.username}.xml?locale=#{locale}"
				title: i18n.__ "RSS feed by user %s", user.username
				site_url: "http://localhost:9000/"
				webMaster: "Anton Shramko"

			Feed = new RSS(Constructor)

			_.each posts, (post) ->
				description = toPlainText post.content.substr(0, 250)+"..."

				Feed.item
					url: "http://localhost:9000/details/#{post.id}"
					author: "#{user.firstname} #{user.lastname}"
					description: description
					date: post.createdAt
					title: post.title

			setTimeout(->
				xml = Feed.xml()
				res.send xml
			, 0)
		)

		.caught (error) ->
			# sails.log.error error
			res.notFound()

	hab: (req, res) ->
		locale  = req.param "locale", "ru"
		nameHab = req.param "name"

		Hab.findOne().where(translitName: nameHab)

		.then((hab) ->
			if hab

				i18n = {
					desc: (_.find(hab.description, "locale": locale)).desc
					name: (_.find(hab.name, "locale": locale)).name
				}

				if !i18n.name or (i18n.name is null) or (Utils.type(i18n.name) is "undefined")
					i18n.name = hab.translitName

				if !i18n.desc or (i18n.desc is null) or (Utils.type(i18n.desc) is "undefined")
					i18n.desc = (_.first(hab.description)).desc
				
				Constructor =
					title: i18n.name
					description: i18n.desc
					feed_url: "http://localhost:9000/rss/hab/#{hab.translitName}/#{locale}.xml"
					site_url: "http://localhost:9000/"
					webMaster: "Anton Shramko"
					language: locale

				Posts = Post.find()
					.where(hab: hab.id, locale: locale)
					.sort("createdAt desc")
					.limit(20)
					.then (posts) -> posts
			
				[hab, Posts, Constructor]
				
			else
				throw new Error "Hab not found"
		)

		.spread((hab, Posts, optionsFeeds) ->
			Feed = new RSS(optionsFeeds)

			_.each Posts, (post) ->
				description = toPlainText post.content.substr(0, 250)+"..."

				Feed.item
					url: "http://localhost:9000/details/#{post.id}"
					description: description
					date: post.createdAt
					title: post.title
					author: ""

			setTimeout(->
				xml = Feed.xml()
				res.send xml
			, 0)
		)

		.caught (error) ->
			sails.log.error error
			res.serverError()

	_config: 
		shortcuts: false 
		actions: false 
		rest: false