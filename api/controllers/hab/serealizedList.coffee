Promise = require "bluebird"
async = require "async"
_ = require "lodash"
map = Promise.promisify(async.map)

module.exports = (req, res) ->

	locale = req.getLocale()

	Hab.find()

	.then((habs) ->
		iterator = (hab, cb) ->
			nameHab = _.find hab.name, "locale": locale

			cb null,
				name: if nameHab then nameHab.name else hab.translitName
				translitName: hab.translitName
				id: hab.id
			return

		habs = map(habs, iterator).then (habs) -> habs
	)

	.then((habs) -> res.json habs)

	.error((errors) ->
		sails.log.error errors
		res.serverError()
	)