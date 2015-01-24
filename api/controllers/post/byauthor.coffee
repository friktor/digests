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

module.exports = (req, res) ->

	username = req.param "username"
	page = req.param "page", 1

	if !username then res.notFound()

	User.findOne(username).populate("avatarImg")

	.then((user) ->
		if !user then res.notFound() else

			# Find and rendered posts by this user.
			postsByThisUser = Post.find().sort("createdAt desc").where(author: user.id).paginate({page: page, limit: 25})
				.then (postsByThisUser) ->

					# Promised function for render posts.
					asyncRenderedPosts = (posts) ->
						new Promise (resolve, reject) ->
							async.map posts, common.renderPost, (error, renderedPosts) ->
								if error then reject(error) else resolve(renderedPosts)
								return
							return

					# return rendered posts 
					asyncRenderedPosts(postsByThisUser).then (rendered) -> rendered

			# Number if subscribers by this user.
			numberOfSubscribers = Subscribe.count({from: "Author", by: user.id}).then (numberOf) -> numberOf

			# return promised
			[user, postsByThisUser, numberOfSubscribers]
	)

	.spread((user, postsByThisUser, numberOfSubscribers) ->
		# If !posts and page > 1 response 404
		if !postsByThisUser[0] and page > 1 then res.notFound() else
			
			# Completed formin object with title and etc..
			completed =
				title: req.__("Posts by %s", "#{user.firstname} #{user.lastname}") + "● Digests.me"
				numberOfSubscribers: numberOfSubscribers
				posts: postsByThisUser
				user: user
				page: page

			# if param ajax is true - send json, else send html
			if req.param("ajax") is "true"
				res.json completed
			else
				res.view completed
	)