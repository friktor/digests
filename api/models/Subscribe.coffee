 # Subscribe.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs				:: http://sailsjs.org/#!documentation/models

randomString = require "random-string"

Subscribe =

	types:
		
		# valid locale {ru || en || pl} without other
		locale: (locale) ->
			/(^ru$|^en$|^pl$)/.test(locale)

	attributes: 

		# Email
		# desc: email options if not registered user.
		# explan: is optional
		
		email: 
			type: "string"
			required: true
			email: true

		# Type 
		#	desc: Variations type for subscribe:
		# variant: 'hab', 'author'

		type:
			type: "string"
			required: true

		# Purpose
		# desc: id targeted subscribe.
		# explan: If 'hab' then hab.id, else if 'author' then user.id

		purpose:
			type: "string"
			required: true

		# Locale
		# desc: locale options for set lang to send email. 
		locale:
			defaultsTo: "ru"
			type: "string"
			locale: true

		# Association for user subscribtions. {user_id || null}
		user: model: "user"

		# Mailing
		# desc: options for send email with posts
		# explan: if subscribe without user associations - always 'true'

		mailing:
			type: "boolean"
			defaultsTo: true

		# Activated
		# desc: options for verify activated subscribe
		# explan: activated after verfify, vefift link in email

		activated:
			type: "boolean"
			defaultsTo: false
			
	beforeCreate: ($Subscribe, next) ->
		$Subscribe.activateToken = randomString length: 20
		next()
		return

module.exports = Subscribe