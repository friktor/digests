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

module.exports = (req, res) ->

	GlobalHabs = Hab.find().where(type: "global").sort("createdAt desc").limit(5).then (habs) -> habs
	LocalHabs = Hab.find().where(type: "local").sort("createdAt desc").limit(5).then (habs) -> habs

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

				Hab.find(tapeId)
			).then (habs) -> habs

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