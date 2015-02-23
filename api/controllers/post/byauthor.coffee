require "coffee-script/register"
common = require "./common.coffee"
Promise = require "bluebird"
async = require "async"
_ = require "lodash"

####
#@action: posts by author
#@description: list posts by author from username
#@params: {page | default: 1}, {username | required}
#@dependencies: defaults {{none}}
####

# Error class for handle promise
notExists = require "../errors/notExists.coffee"

module.exports = (req, res) ->

	username = req.param "username"
	page = req.param "page", 1

	if !username then res.notFound()

	User.findOneByUsername(username).populate("avatarImg")

	.then((user) ->
		if !user then throw new notExists() else

			# Number if subscribers by this user.
			numberOfSubscribers = Subscribe.count({from: "Author", by: user.id}).then (numberOf) -> numberOf

			# Posts by user
			postsByThisUser = common.FindAndRenderPostsByThisUser(user.id, page).then (posts) -> posts

			# return promised
			[user, postsByThisUser, numberOfSubscribers]
	)

	.spread((user, postsByThisUser, numberOfSubscribers) ->

		# If !posts and page > 1 response 404
		if !postsByThisUser[0] and page > 1 then res.notFound() else
			
			# Completed formin object with title and etc..
			completed =
				title: req.__("Posts by %s", "#{user.firstname} #{user.lastname}") + " · Digests.me"
				numberOfSubscribers: numberOfSubscribers
				posts: postsByThisUser
				user: user
				page: page

			# if param json is true - send json, else send html
			if req.param("json") is "true"
				res.json completed
			else
				res.view completed
	)

	.caught(notExists, (e) ->
		res.notFound()
	)

	.caught (e) ->
		sails.log.error e
		res.serverError()