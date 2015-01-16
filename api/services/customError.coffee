module.exports =

	# Broken token error
	brokenTokenError : class brokenTokenError extends Error
		constructor: (@message) ->
			@name = "brokenToken"
			Error.captureStackTrace(this, brokenTokenError)
	
	# Does not exists
	notExists : class notExists extends Error
		constructor: (@message) ->
			@name = "notExists"
			Error.captureStackTrace(this, notExists)