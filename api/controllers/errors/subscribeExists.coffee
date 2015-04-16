module.exports = class subscribeExists extends Error
	constructor: (@message) ->
		@name = "subscribeExists"
		Error.captureStackTrace(this, subscribeExists)