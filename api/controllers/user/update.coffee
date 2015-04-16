# @name: update
# @description: update info for user
# @dependencies: nodemailer, bluebird, i18n
# @params: {username, [params]} by POST
# @rest: GET "/utils/user/update"

require "coffee-script/register"
notExists = require "../errors/notExists.coffee"

module.exports = (req, res) ->

	username = req.param "username"

	res.badRequest() if !username

	User.findOneByUsername(username)

	.then((user) ->
		if user
			params = 
				activitiesMe: req.param "activitiesMe", user.activitiesMe
				firstname: req.param "firstname", user.firstname
				lastname: req.param "lastname", user.lastname
				aboutMe: req.param "aboutMe", user.aboutMe
			
			[user, params]
		else
			throw new notExists()
	)

	.spread((user, params) ->
		User.update(user.id, params)
	)

	.then((updatedUser) ->
		user = updatedUser[0]

		res.json
			message: req.__ "Personal information updated!"
			success: true
			user: user
	)

	.caught(notExists, (e) ->
		res.badRequest()
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)
