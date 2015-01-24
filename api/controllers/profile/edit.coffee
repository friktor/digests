require "coffee-script/register"

# utils type function
type = require("../../services/Utils.coffee").type

# Error class for handle promise
notExists = require "../errors/notExists.coffee"

module.exports = (req, res) ->
	username = req.param "username"
	post = req.param "post"

	res.notFound() if !username or !post

	User.findOneByUsername(username)
	.populate("headingImg")
	.populate("avatarImg")

	.then((user) ->
		if type(user) is "undefined" then throw new notExists() else
			post = Post.findOne(numericId: post).then (post) -> post
			[user, post]
	)

	.spread((user, post) ->
		if !post then throw new notExists() else
			res.view
				title: req.__("Edit post “%s” by %s %s", post.title, user.firstname, user.lastname)+" ● Digests.me"
				user: user
				post: post
	)

	.caught(notExists, (e) ->
		res.notFound()
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)