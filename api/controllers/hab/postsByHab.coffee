require "coffee-script/register"

commonPost = require "../post/common.coffee"
commonHab = require "./common.coffee"

renderPost = commonPost.renderPost
Promise = require "bluebird"
_ = require "lodash"

map = Promise.promisify(require("async").map)

# Error class for handle promise
notExists = require "../errors/notExists.coffee"

module.exports = (req, res) ->

	locale = req.param "locale"	
	name = req.param "name"

	# Page for sort
	page = try
		parseInt(req.param("page", 1))
	catch e
		1

	# Define empty where
	where = {}

	# Paginate options
	paginate = 
		page: page
		limit: 25

	# Switch validate for and set locale.
	switch true
		when /(^ru$|^en$|^pl$)/.test(locale)
			where.locale = locale
		else
			where.locale = locale = commonPost.getLocaleGlobal(req.cookies.locale, req.headers["accept-language"])

	# Promised fucntion for forming habs
	formingHab = Promise.promisify _.partial(commonHab.iteratorForming, locale, "full")
		
	Hab.findOne("translitName": name).populate("headingImg").then((hab) ->
		if !hab then throw new notExists() else 
			
			# Main Merge options where/
			where = _.merge("hab": "contains": hab.id, where)

			# forming Hab object
			cleanHab = formingHab(hab).then (forming) -> forming

			# Promised async fond posts by params hab/
			posts = Post.find(where)
				.sort("createdAt desc")
				.populate("headerImg")
				.paginate(paginate)
				.then (posts) -> 
					rendered = map(posts, renderPost)
						.then (rendered) -> rendered
			
			# return promised spread array
			[cleanHab, posts]
	)

	.spread((hab, posts) ->
		if !posts[0] then throw new notExists() else
			forming =
				title: req.__("Hab %s", hab.name)+ " · Digests.me · " + req.__("page %s", page)
				locale: locale
				posts: posts
				page: page
				hab: hab
	
			switch req.param "ajax"
				when "true"
					# delete forming.hab
					res.json forming
				else res.view forming
	)

	.caught(notExists, (e) ->
		res.notFound()
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)