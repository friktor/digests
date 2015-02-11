Promise = require "bluebird"
async = require "async"
_ = require "lodash"


module.exports = (req, res) ->

	locale = req.getLocale()

	Hab.find()

	.then((habs) ->
		asyncFormingList = ->
			new Promise (resolve, reject) ->
				iterator = (hab, cb) ->
					nameHab = _.find hab.name, "locale": locale

					cb null,
						name: if nameHab then nameHab.name else hab.translitName
						translitName: hab.translitName
						id: hab.id
					return

				async.map habs, iterator, (errors, result) -> 
					if errors then reject(errors) else resolve(result)
					return
				return

		habs = asyncFormingList().then (habs) -> habs
		return habs
	)

	.then((habs) -> res.json habs)

	.error((errors) ->
		sails.log.error errors
		res.serverError()
	)