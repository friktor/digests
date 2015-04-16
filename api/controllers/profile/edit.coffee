require "coffee-script/register"

Promise = require "bluebird"

# utils type function
type = require("../../services/Utils.coffee").type

# Error class for handle promise
notExists = require "../errors/notExists.coffee"

_ = require "lodash"

module.exports = (req, res) ->
	username = req.param "username"
	locale = req.getLocale()
	post = req.param "post"

	res.notFound() if !username or !post

	User.findOneByUsername(username)

	.then((user) ->
		if type(user) is "undefined" then throw new notExists() else
			post = Post.findOne(numericId: post).then (post) -> post
			[user, post]
	)

	.spread((user, post) ->
		if !post then throw new notExists() else
			_object = 
				user: user
				post: post

			asyncMapHabsFromId = ->
				new Promise (resolve, reject) ->
					Hab.find(post.hab.split(/\s*,\s*/)).then (habs) ->
					
						iterator = (hab, cb) ->
							nameHab = _.find hab.name, "locale": locale
		
							cb null,
								name: if nameHab then nameHab.name else hab.translitName
								translitName: hab.translitName
								id: hab.id
							return
		
						async.map habs, iterator, (errors, result) -> 
							if errors then reject(errors) else resolve(result)
							return
						return
					return

			asyncMapHabsFromId().then (habs) ->
				_object.post.tags = post.tags.split(/\s*,\s*/)
				_object.post.habs = habs

				if req.param("json", false) is "true"
					res.json _object
				else
					res.view _.merge _object,
						title: req.__("Edit post “%s” by %s %s", post.title, user.firstname, user.lastname)+" · Digests.me"
	)

	.caught(notExists, (e) ->
		res.notFound()
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)