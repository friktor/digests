require "coffee-script/register"

# utils type function
type = require("../../services/Utils.coffee").type

# Error class for handle promise
notExists = require "../errors/notExists.coffee"

module.exports = (req, res) ->
	username = req.param "username"

	res.notFound() if !username

	User.findOneByUsername(username)
	.populate("headingImg")
	.populate("avatarImg")

	.then((user) ->
		if type(user) is "undefined"
			throw new notExists "User does not exists"
		else
			if req.param("user-data") is "true"
				res.json user
			else
				res.view
					title: req.__("Settings %s", user.username)+" · Digests.me"
					user: user
	)