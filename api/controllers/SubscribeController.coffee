 # SubscribeController
 #
 # @description :: Server-side logic for managing subscribes
 # @help        :: See http://links.sailsjs.org/docs/controllers

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
	
	create: (req, res) ->
		params = 
			locale: req.param "locale", "ru"
			email: req.param "email"
			from: req.param "from"
			user: req.param "user"
			by: req.param "by"

		# Main Action
		Subscribe.findOne().where(params)
			
			# Finded subscribe
			.then((subscribe) ->
				if !subscribe
					Subscribe.create(params)
				else
					throw new subscribeExists "subscribe is exists"
				
			)

			# Send mail after create subscribe
			.then((subscribe) ->
				
				res.json
					success: true
					message: req.__ "Congratulations! You request a subscription. To your email sent instructions to activate your subscription."
				
				mailingCommon.subscribeCreate(
					token: subscribe.activateToken
					locale: subscribe.locale
					email: subscribe.email
					id: subscribe.id
				)
				return
			)

			# Handle if subscribe is exists
			.caught(subscribeExists, (e) ->
				# sails.log.error e
				res.json
					success: false
					message: req.__ "Error! Subscribe is exists."
			)


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

						res.view()
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