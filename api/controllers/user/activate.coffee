# @name: activate
# @description: activate user account
# @dependencies: nodemailer, bluebird, i18n
# @params: {id, token} by GET
# @rest: GET "/utils/activate"

require "coffee-script/register"
notExists = require "../errors/notExists.coffee"

module.exports = (req, res) ->
	token = req.param "token"
	id = req.param "id"

	User.findOne(id).then((user) ->
		if !user then throw new notExists() else
			switch user.activationToken is token
				when true
					user.activation = true
					user.save()
				else
					res.badRequest()
	)

	.caught(notExists, (e) ->
		res.badRequest()
	)