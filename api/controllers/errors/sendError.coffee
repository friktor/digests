# Send Error
class sendError extends Error
	constructor: (@message) ->
		@name = "sendError"
		Error.captureStackTrace(this, sendError)