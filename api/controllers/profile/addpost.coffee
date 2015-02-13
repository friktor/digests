require "coffee-script/register"

# utils type function
type = require("../../services/Utils.coffee").type

# Error class for handle promise
notExists = require "../errors/notExists.coffee"

module.exports = (req, res) ->
	username = req.param "username"

	res.notFound() if !username

	User.findOneByUsername(username)

	.then((user) ->
		res.view
			title: req.__("Add new post")+" ⚫ Digests.me"
			user: user
	)

	.caught(notExists, (e) ->
		res.notFound()
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)