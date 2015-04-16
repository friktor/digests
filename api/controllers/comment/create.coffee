# dependencies
md = require("../post/common.coffee").markdown
Promise = require "bluebird"
xss = require "xss"

module.exports = (req, res) ->

	params = 
		replyTarget: req.param "replyTarget"
		message: req.param "message"
		author: req.param "author"
		target: req.param "target"
		reply: req.param "reply"

	User.findOneByUsername(params.author).populate("avatarImg").then((user) -> 
		if !user then throw new Error("Author isnt exists") else
			comment = Comment.create(_.merge(params, author: user.id)).then (comment) -> comment
			[comment, user]
	)

	.spread((comment, author) ->
		avatars = _.find(author.avatarImg, "restrict": "preview")
		
		message = xss md.render(comment.message),
			whiteList: sails.config.xss
			stripIgnoreTag: false
		
		$author =
			username: author.username
			firstname: author.firstname
			lastname: author.lastname
			avatars: avatars.link or false

		_.merge comment,
			replyTarget: comment.replyTarget
			reply: comment.reply
			message: message
			author: $author
	)

	.then((comment) ->
		res.json 
			comment: comment
			success: true
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)