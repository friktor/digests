############
# MATCHES: Post from request:
# regexp: /(post)-(\d{2}.\d{2}.\d{2}-\d{6,10})/
# 
# "post-05.05.15-123456"
# |___| |______________|
#  ar1        arg2
# 
# ar1 - finder type, ar2 - subject (id)
############

require "coffee-script/register"

# dependencies
Promise = require "bluebird"

md = require("../post/common.coffee").markdown
map = Promise.promisify(require("async").map)
_ = require "lodash"
xss = require "xss"

# errors
notExists = require "../errors/notExists.coffee"

module.exports = (req, res) ->

	target = req.param "target"

	isValid = switch true
		when /(post)-(\d{2}.\d{2}.\d{2}-\d{6,10})/.test(target) then true
		else false

	if !isValid then res.badRequest() else

		Comment.find().where(target: target).sort("createdAt desc")

		.then((comments) ->
			
			if !comments then throw new notExists() else
				iteratorRender = (comment, cb) ->
					User.findOne(comment.author).populate("avatarImg").exec (error, user) ->
						message = xss md.render(comment.message),
							whiteList: sails.config.xss
							stripIgnoreTag: false

						avatars = _.find(user.avatarImg, "restrict": "preview")

						author = 
							firstname: user.firstname
							username: user.username
							lastname: user.lastname
							avatars: avatars.link or false
	
						cb error, _.merge comment, 
							message: message
							author: author
						return
					return

				rendered = map(comments, iteratorRender).then (rendered) -> rendered
		)

		.then((comments) ->
			res.json 
				numberOf: comments.length 
				comments: comments
		)

		.caught(notExists, (e) ->
			res.badRequest()
		)

		.caught((error) ->
			sails.log.error error
			res.serverError()
		)