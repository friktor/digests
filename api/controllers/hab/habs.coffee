# Sinopsis and Content
# Type show:
# 	a) Hab - show one selected hab
# 	b) Global - show all global habs
# 	c) Local - show all local habs
# 	d) Not set - show starter page with:
# 		* 5 global habs
# 		* 5 local habs
# 		* by subscribes

require "coffee-script/register"

Promise = require "bluebird"
map = Promise.promisify(require("async").map)
common = require "./common.coffee"

_ = require "lodash"

module.exports = (req, res) ->
	locale = req.getLocale()
	iteratorForming = _.partial(common.iteratorForming, locale, "preview")

	GlobalHabs = Hab.find()
		.populate("headingImg")
		.where(type: "global")
		.sort("createdAt desc")
		.limit(6)
		.then (habs) -> map(habs, iteratorForming)

	LocalHabs = Hab.find()
		.populate("headingImg")
		.where(type: "local")
		.sort("createdAt desc")
		.limit(6)
		.then (habs) -> map(habs, iteratorForming)

	if req.session.auth and req.session.user
		
		_paramSearch = 
			user: req.session.user.id
			type: "hab"
		
		UserHabsSubscribtions = Subscribe.find(_paramSearch)
			.then((subscribes) ->
				tapeId = []
				subscribes.forEach (subscribe) ->
					tapeId.push subscribe.purpose
					return

				Hab.find(tapeId).populate("headingImg").sort("createdAt desc").limit(6)
			).then (habs) -> map(habs, iteratorForming)

	Promise.join(GlobalHabs, LocalHabs, UserHabsSubscribtions, (global, local, bySubscribe) ->
		res.view
			title: req.__("Habs") + " · Digests.me"
			bySubscribe: bySubscribe
			global: global
			local: local
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)