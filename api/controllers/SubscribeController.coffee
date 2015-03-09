 # SubscribeController
 #
 # @description :: Server-side logic for managing subscribes
 # @help        :: See http://links.sailsjs.org/docs/controllers

require "coffee-script/register"

Promise = require "bluebird"
readFile = Promise.promisify(require("fs").readFile);
ejs = require "ejs"


# Broken token error
class brokenTokenError extends Error
	constructor: (@message) ->
		@name = "brokenToken"
		Error.captureStackTrace(this, brokenTokenError)


# Does not exists
class notExists extends Error
	constructor: (@message) ->
		@name = "notExists"
		Error.captureStackTrace(this, notExists)

# Exists
class subscribeExists extends Error
	constructor: (@message) ->
		@name = "subscribeExists"
		Error.captureStackTrace(this, subscribeExists)


# Main Eventer
module.exports = 
	
	create: require "./subscribe/create.coffee"


	activateSubscribe: (req, res) ->

		subscribeId = req.param "id"
		token = req.param "token"

		return res.badRequest() if !subscribeId or !token

		Subscribe.findOne()
			.where(id: subscribeId)
			
			.then((subscribe) ->

				if subscribe
					if subscribe.activateToken is token
						subscribe.activated = true
						subscribe.save()

						res.redirect "/"
					else
						throw new brokenTokenError "request subscribe is exists, but request token isnt valid"
				else
					throw new MyCustomError "subscribe does not exists"
			)

			.caught(brokenTokenError, (e) ->
				sails.log e
				res.serverError()
			)

			.caught(notExists, (e) ->
				sails.log e
				res.serverError()
			)

	destroy: (req, res) ->
		id = req.param "id"

		res.badRequest() if !id

		Subscribe.findOne(id)

		.then((subscribe) ->
			if !subscribe then res.serverError("Subscribe does not exists") else
				[subscribe, Subscribe.destroy(subscribe.id)]
		)

		.spread((subscribe) ->
			res.json
				subscribe: subscribe.id
				success: true
		)

		.caught (error) ->
			sails.log.error error
			res.serverError()

	_config: 
		shortcuts: false 
		actions: false 
		rest: false
