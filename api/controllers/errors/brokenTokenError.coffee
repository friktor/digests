module.exports = class brokenTokenError extends Error
	constructor: (@message) ->
		@name = "brokenToken"
		Error.captureStackTrace(this, brokenTokenError)