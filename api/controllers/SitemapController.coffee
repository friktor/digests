sitemap = require "sitemap"

website = "http://digests.me"

module.exports = 
	posts: (req, res) ->
		mapPosts = [ ]

		Post.find().sort("createdAt desc")

		.then((posts) ->
			_.each posts, (post) ->
				mapPosts.push
					url: "/details/#{post.id}"
					changefreq: "monthly"
					priority: 0.5
				return

			setTimeout(->
				Sitemap = sitemap.createSitemap
					hostname: website
					cacheTime: 600000
					urls: mapPosts

				Sitemap.toXML (xml) ->
					res.header "Content-Type", "application/xml"
					res.send xml
			, 0)
		)

		.caught((error) ->
			sails.log.error error
			res.serverError()
		)

	profiles: (req, res) ->

		mapUsers = [ ]

		User.find().sort("createdAt desc")

		.then((users) ->
			_.each users, (user) ->
				mapUsers.push
					url: "/profile/#{user.username}"
					changefreq: "monthly"
					priority: 0.5
				return

			setTimeout(->
				Sitemap = sitemap.createSitemap
					hostname: website
					cacheTime: 600000
					urls: mapUsers

				Sitemap.toXML (xml) ->
					res.header "Content-Type", "application/xml"
					res.send xml					
			, 0)
		)

		.caught((error) ->
			sails.log.error error
			res.serverError()
		)

	otherwise: (req, res) ->

		Sitemap = sitemap.createSitemap
			hostname: website
			cacheTime: 600000
			urls: [
				{
					changefreq: "monthly"
					priority: 0.8
					url: "/"
				}
			]

		Sitemap.toXML (xml) ->
			res.header "Content-Type", "application/xml"
			res.send xml

	_config: 
		shortcuts: false 
		actions: false 
		rest: false
