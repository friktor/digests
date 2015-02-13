require "coffee-script/register"
common = require "./common.coffee"
async = require "async"
_ = require "lodash"

# Error class for handle promise
notExists = require "../errors/notExists.coffee"

####
#@action: list latest posts
#@description: list all posts with json response for ajax
#@params: {page | default: 1}, {locale | default: "ru"}
#@dependencies: xss, async, i18n
####

module.exports = (req, res, next) ->
	
	# Locale (Language) set forming
	locale = if req.param("locale")
		req.param("locale") 
	else common.getLocaleGlobal(req.cookies.locale, req.headers["accept-language"])

	# Page for sort
	page = parseInt(req.param("page", 1))
	page = if isNaN(page) then 1 else page

	# Sort by Language / View all
	where = new Object()
	where.locale = if req.param("locale") and req.param("locale") is "all"
		undefined
	else
		locale

	Post.find().populate("headerImg")

	# sort params
	.sort("createdAt desc")

	# where params
	.where(where)

	# paginate options
	.paginate(
		page: page
		limit: 25
	)

	.then((posts) ->
		# If not posts on this page - send 404.
		if !posts[0] then throw new notExists() else
			# Async rendered posts. 
			async.map posts, common.renderPost, (error, renderedPosts) ->
				# Copleted array with rendered posts. Title & page & posts
				completed =
					title: req.__("Latest") + " ⚫ Digests.me ⚫ " + req.__("%s page", page)
					posts: renderedPosts
					locale: locale
					page: page

				# if param ajax is true - send json, else send html.
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
		res.serverError()