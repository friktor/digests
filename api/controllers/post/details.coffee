require "coffee-script/register"

Promise = require "bluebird"
async = require "async"
_ = require "lodash"
xss = require "xss"

# Common utils functions
common = require "./common.coffee"

# Error class for handle promise
notExists = require "../errors/notExists.coffee"

####
#@action: details view post
#@description: details show post - with render markdown, with comments
#@params: {id | post_id, required}
#@dependencies: remarkable(markdown parser)
####

module.exports = (req, res, next) ->
	id = req.param "id"

	if !id then res.notFound() else

		Post.findOne()

		.where(or: [
			{numericId: id}
			{id: id}
		])

		.then((post) ->
			if !post then throw new notExists() else
				
				# Showed increment
				post.showed = 0 if !post.showed
				post.showed += 1
				post.save()

				# Render and protect content
				post.content = xss common.markdown.render(post.content),
					whiteList: sails.config.xss
					stripIgnoreTag: false

				# @Author association for this post
				Author = User.findOne(post.author).populate("avatarImg").then (user) -> user.toJSON()
				
				# @List Habs for this post
				promisedGetHabs = ->
					new Promise (resolve, reject) ->
						# Find And Push Habs.
						iteratorHab = (habId, cb) ->
							Hab.findOne(habId).then (hab) ->
								if hab
									cb null, 
										translitName: hab.translitName
										name: hab.name
										id: hab.id
								else
									cb()
								return

						# Async find using iterator
						async.map post.hab.split(/\s*,\s*/), iteratorHab, (error, Habs) ->
							if error then reject(error) else resolve(Habs)
							return
						return 

				Habs = promisedGetHabs().then (habs) -> habs

				[post, Author, Habs]
		)

		.spread((post, author, habs) ->
			# response rendered html
			res.json
				title  : post.title + " ⚫ Digests.me"
				author : author
				post   : post
				habs   : habs
		)

		.caught(notExists, (e) ->
			res.notFound()
		)

		.caught((error) ->
			sails.log.error error
			res.serverError()
		)