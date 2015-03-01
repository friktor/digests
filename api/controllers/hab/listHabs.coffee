require "coffee-script/register"

Promise = require "bluebird"
map = Promise.promisify(require("async").map)
common = require "./common.coffee"

_ = require "lodash"

module.exports = (req, res) ->

	project = false

	switch req.param "type", "global"
		when "locals" 
			type = "local"
		when "globals" 
			type = "global"
		when "projects"
			type = "local"
			project = true
		else type = "global"

	locale = req.getLocale()

	# Page for sort
	page = try
		parseInt(req.param("page", 1))
	catch e
		1

	# where options
	where = 
		project: project
		type: type		

	# Paginate options
	paginate = 
		page: page
		limit: 25


	Hab.find().where(where).populate("headingImg").paginate(paginate)
	
	.then((habs) -> 
		# Itearator forming habs list
		map habs, _.partial(common.iteratorForming, locale, "preview")
	)

	.then((habs) ->
		if !habs[0] and page > 1 then res.notFound() else
			res.view
				title: req.__("Habs - %s", type)+" · Digests.me · "+req.__("page %s", page)
				habs: habs
				page: page 
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)