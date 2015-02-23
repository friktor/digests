require "coffee-script/register"

common = require "./common.coffee"
Promise = require "bluebird"
moment = require "moment"
async = require "async"
_ = require "lodash"

# Error class for handle promise
notExists = require "../errors/notExists.coffee"

# Promisify
map = Promise.promisify(async.map)

#@action: list latest populars posts
#@description: list all posts with json response for ajax
#@params: {page | default: 1}, {locale | default: "ru"}
#@dependencies: xss, async, i18n

module.exports = (req, res) ->

	locale = req.param "locale", null

	# Page (req.param) for slice
	page = try
		parseInt(req.param("page", 1))
	catch e
		1

	# Where data
	where = createdAt: ">": moment().subtract(21, "d").toDate()

	# Switch validate for and set locale.
	switch true
		when /(^ru$|^en$|^pl$)/.test(locale)
			where.locale = locale
		else
			where.locale = locale = common.getLocaleGlobal(req.cookies.locale, req.headers["accept-language"])

	# Main Action
	Post.find().populate("headerImg")

	# Set "where" param
	.where(where)

	# Set "sort" options
	.sort("showed desc")
	
	# Paginate options
	.paginate(
		page: page
		limit: 20
	)

	.then((posts) ->
		# If not posts on this page - send 404.
		if !posts[0] then throw new notExists() else
			renderedPosts = map(posts, common.renderPost).then (posts) -> posts
	)

	.then((posts) ->
		Forming =
			title: req.__("Popular") + " · Digests.me · " + req.__("%s page", page)
			locale: locale
			posts: posts
			page: page

		switch req.param("ajax")
			when "true" then res.json Forming
			else res.view Forming
	)

	.caught(notExists, (e) ->
		res.notFound()
	)

	.caught (error) ->
		sails.log.error error
		res.json error.toJSON()