require "coffee-script/register"
common = require "./common.coffee"
moment = require "moment"
async = require "async"
_ = require "lodash"

# Error class for handle promise
notExists = require "../errors/notExists.coffee"

#@action: list latest populars posts
#@description: list all posts with json response for ajax
#@params: {page | default: 1}, {locale | default: "ru"}
#@dependencies: xss, async, i18n

module.exports = (req, res) ->

	# Locale (Language) set forming
	locale = if req.param("locale")
		req.param("locale") 
	else common.getLocaleGlobal(req.cookies.locale, req.headers["accept-language"])

	# Page (req.param) for slice
	page = parseInt(req.param("page", 1))
	page = if isNaN(page) then 1 else page

	# Where data
	where = createdAt: ">": moment().subtract(21, "d").toDate()

	# Sort by Language / View all
	where.locale = if req.param("locale") and req.param("locale") is "all"
		undefined
	else
		locale

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

	# Promise success
	.then((posts) ->
		
		# If not posts - send 404 error
		if !posts[0] then throw new notExists() else

			# Async rendered content. And cut content to sinopsis
			async.map posts, common.renderPost, (error, renderedPosts) ->
				completed =
					title: req.__("Popular posts") + "⚫ Digests.me ⚫" + req.__("%s page", page)
					posts: renderedPosts
					page: page

				# response data
				if req.param("ajax") is "true"
					res.json completed
				else
					res.view completed
				return
	)

	.caught(notExists, (e) ->
		res.notFound()
	)

	.caught (error) ->
		sails.log.error error
		res.json error.toJSON()