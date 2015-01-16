 # ProfileController
 #
 # @description :: Server-side logic for managing profiles
 # @help        :: See http://links.sailsjs.org/docs/controllers

Promise = require "bluebird"

module.exports = {

	index: (req, res) ->
		username = req.param "username"
		
		if !username
			return res.notFound()
		else
			User.findOne(username: username).populate("avatarImg").populate("headingImg")
			
			.then((user) ->
				if!user
					res.notFound()
				else
					latestPost = Post.find({where: {author: user.id}, sort: "createdAt desc"}).then (posts) ->
						return posts[0]

					countPosts = Post.count(where: author: user.id).then (count) ->
						return count

					countComments = Comment.count(where: author: user.id).then (count) -> 
						return count

					subscribes = Subscribe.count({from: "Author", by: user.id}).then (count) -> count
	
					[user, countPosts, latestPost, countComments, subscribes]
			)

			.spread((user, countPosts, latestPost, countComments, subscribes) ->

				res.view
					title: req.__("Profile %s", user.username)
					countComments: countComments
					countPosts: countPosts
					latestPost: latestPost
					countSubscribes: subscribes
					user: user
			)

			.caught((error) ->
				sails.log.error error
				res.serverError()
			)


	addpost: (req, res) ->
		username = req.param "username"
		if !username
			res.notFound()
		else
			User.findOneByUsername(username).populate("avatarImg")

			.then((user) ->
				Habs = Hab.find().then (habs) -> habs

				[user, Habs]
			)

			.spread((user, habs) ->
				
				res.view
					title: req.__("Add Article")
					user: user
					habs: habs
			)

			.catch (error) ->
				sails.log.error error
				res.serverError()


	settings: (req, res) ->
		username = req.param "username"
		res.notFound() if !username

		User.findOneByUsername(username).populate("avatarImg")

		.then((user) ->
			if user
				res.view
					title: "#{req.__("Settings %s", user.username)}"
					user: user
			else
				throw new Error "user does not exits"				
		)

		.caught((e) ->
			sails.log.error e
			res.notFound()
		)


	edit: (req, res) ->
		username = req.param "username"
		post = req.param "post"

		User.findOneByUsername(username)

		.then((user) ->
			if not user then throw new Error "user does not exits" else
				post = Post.findOneById(post).then (post) -> post 
				habs = Hab.find().then (habs) -> habs

				[user, post, habs]	
		)

		.spread((user, post, habs) ->		
			if !post then throw new Error "post does not exists" else
				res.view
					title: req.__ "Edit post “%s” by %s %s", post.title, user.firstname, user.lastname
					post: post
					user: user 
					habs: habs
		)

		.catch((e) -> res.notFound())

	subscribes: (req, res) ->

		username = req.param "username"

		User.findOneByUsername(username)

		.then((user) ->
			if !user then res.notFound() else
				serealizedSubscribes = (user) ->
					new Promise (resolve, reject) ->
						Subscribe.find(user: user.id).then((subscribes) ->
							
							iteratorSubscribe = (subscribe, cb) ->
								if subscribe.from is "Hab"
									Hab.findOne(subscribe.by).then (hab) ->
										cb null, _.merge subscribe, info: 
											content: hab
											type: "Hab"
										return
								else if subscribe.from is "Author"
									User.findOne(subscribe.by).populate("avatarImg").then (user) ->
										cb null, _.merge subscribe, info:
											content: user.toJSON()
											type: "Author"
										return
								return

							async.map subscribes, iteratorSubscribe, (error, result) ->
								if error then reject(error) else resolve(result)
								return
							return
						)
				[user, serealizedSubscribes(user)]
		)

		.spread((user, subscribes) ->
			res.view
				title: req.__ "Subscription user %s", user.username
				subscribes: subscribes
				user: user
		)

		.error (error) ->
			sails.log.error error
			res.serverError()

			
	_config: 
		shortcuts: false 
		actions: false 
		rest: false
}