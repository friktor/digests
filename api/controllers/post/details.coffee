require "coffee-script/register"

Promise = require "bluebird"
moment = require "moment"
async = require "async"
_ = require "lodash"
xss = require "xss"

# Common utils functions
common = require "./common.coffee"

# Error class for handle promise
notExists = require "../errors/notExists.coffee"

# Promisify
map = Promise.promisify(async.map)

####
#@action: details view post
#@description: details show post - with render markdown, with comments
#@params: {id | post_id, required}
#@dependencies: remarkable(markdown parser)
####

module.exports = (req, res, next) ->
	locale = req.getLocale()
	id = req.param "id"

	if !id then res.notFound() else

		Post.findOne().populate("headerImg")

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

				# Fomrating created date
				moment.locale(locale)
				post.createdAt = moment(post.createdAt).format("LL")

				# Render and protect content
				post.content = xss common.markdown.render(post.content),
					whiteList: sails.config.xss
					stripIgnoreTag: false

				# @Author association for this post
				Author = User.findOne(post.author).populate("avatarImg").then (user) -> user.toJSON()

				# @Habs parse & find habs
				Habs = map(post.hab.split(/\s*,\s*/), _.partial(common.iteratorHab, locale)).then (habs) -> habs

				[post, Author, Habs]
		)

		.spread((post, author, habs) ->
			# response rendered html
			res.view
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