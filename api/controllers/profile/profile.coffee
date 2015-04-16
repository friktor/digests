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
			numberOfComments = Comment.count(where: author: user.id).then (numberOf) -> numberOf
			numberOfPosts = Post.count(where: author: user.id).then (numberOf) -> numberOf
			[user, numberOfPosts, numberOfComments]
	)

	.spread((user, numberOfPosts, numberOfComments) ->
		
		responseObject = 
			title: req.__("Profile %s", username)+" · Digests.me"
			numberOfComments: numberOfComments
			numberOfPosts: numberOfPosts
			user: _.merge(user, 

				# Autofind full avatar
				"avatarImg": try
					_.find(user.avatarImg, "restrict": "full").link
				catch e
					"/images/avatar.png"

				# Autofind full avatar
				"headingImg": try
					_.find(user.headingImg, "restrict": "full").link
				catch e
					"/images/profile.jpg"

				# Navbarbg
				"navbarBg": try
					_.find(user.headingImg, "restrict": "navbarBg").link
				catch e
					"/images/profile.navbar.jpg"					
				
			)

		widget = req.param "widget", "false"

		if widget is "true"
			res.view "widgets/user.profile", responseObject
		else
			res.view responseObject
		return
	)

	.caught(notExists, (e) ->
		res.notFound()
	)

	.caught (error) ->
		sails.log.error error
		res.serverError()