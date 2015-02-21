# Sinopsis and Content
# Type show:
# 	a) Hab - show one selected hab
# 	b) Global - show all global habs
# 	c) Local - show all local habs
# 	d) Not set - show starter page with:
# 		* 5 global habs
# 		* 5 local habs
# 		* by subscribes

Promise = require "bluebird"
map = Promise.promisify(require("async").map)
_ = require "lodash"

module.exports = (req, res) ->
	locale = req.getLocale()

	iteratorTranslate = (hab, cb) ->
		desc = _.find(hab.description, "locale": locale)
		name = _.find(hab.name, "locale": locale)
		image = _.find(hab.headingImg, "restrict": "preview")

		cb null, _.merge hab, 
			name: name.name or hab.translitName
			description: desc.desc or null
			headingImg: false
			headingImage: try
				size: image.imagesize
				link: image.link
			catch e
				false
			
		return

	GlobalHabs = Hab.find()
		.populate("headingImg")
		.where(type: "global")
		.sort("createdAt desc")
		.limit(6)
		.then (habs) -> map(habs, iteratorTranslate)

	LocalHabs = Hab.find()
		.populate("headingImg")
		.where(type: "local")
		.sort("createdAt desc")
		.limit(6)
		.then (habs) -> map(habs, iteratorTranslate)

	if req.session.auth and req.session.user
		
		_paramSearch = 
			user: req.session.user.id
			from: "Hab"
		
		UserHabsSubscribtions = Subscribe.find(_paramSearch)
			.then((subscribes) ->
				tapeId = []
				subscribes.forEach (subscribe) ->
					tapeId.push subscribe.by
					return

				Hab.find(tapeId).populate("headingImg").sort("createdAt desc").limit(6)
			).then (habs) -> map(habs, iteratorTranslate)

	Promise.join(GlobalHabs, LocalHabs, UserHabsSubscribtions, (global, local, bySubscribe) ->
		res.view
			title: req.__("Habs") + " ⚫ Digests.me"
			bySubscribe: bySubscribe
			global: global
			local: local
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)