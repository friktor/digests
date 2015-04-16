Promise = require "bluebird"
RSS = require "rss"
xss = require "xss"


markdown = require("../post/common.coffee").markdown
notExists = require "../errors/notExists.coffee"

module.exports = (req, res) ->

	username = req.param "username"

	User.findOneByUsername(username).populate("avatarImg").then((user) ->
		if !user then throw new notExists() else
			posts = Post.find(author: user.id).sort("createdAt desc").limit(20).then (posts) -> posts
			[user, posts]
	)

	.spread((user, posts) ->

		Feeds = new RSS
			feed_url: "http://digests.me/rss/author/"+user.username+".xml"
			title: req.__ "RSS by %s %s", user.firstname, user.lastname
			webMaster: "Anton Shramko <dev@digests.me>"
			description: req.__ "personal feed"
			site_url: "http://digests.me/"

		posts.forEach (post, index) ->
			content = xss markdown.render(post.content), 
				stripIgnoreTagBody: ['script']				
				stripIgnoreTag: true 
				whiteList: []

			Feeds.item
				url: "http://digests.me/details/"+post.numericId
				author: user.firstname+" "+user.lastname
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
		return
	)