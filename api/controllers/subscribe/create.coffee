require "coffee-script/register"

brokenTokenError = require "../errors/brokenTokenError.coffee"
subscribeExists = require "../errors/subscribeExists.coffee"

module.exports = (req, res) ->

	# Params for create
	params = 
		mailing : req.param "mailing"
		locale  : req.param "locale"
		email   : req.param "email"
		user    : req.param "user"
		
		purpose : req.param "purpose"
		type    : req.param "type"

	# params for find exists
	findExists = 
		purpose : req.param "purpose"
		email   : req.param "email"
		type    : req.param "type"
		user    : req.param "user"

	# Find Subscribe by params
	Subscribe.findOne(findExists).then((subscribe) ->
		if !subscribe then throw new subscribeExists() else Subscribe.create(params)
	)

	.then((subscribe) ->
		# response success
		res.json 
			success: true
		
		# Send activation email
		common.sendMailAfterCreateSubscribe(subscribe)
	)

	.caught(subscribeExists, (error) ->
		res.json
			throw : "subscribe already is exists"
			success: false

	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)