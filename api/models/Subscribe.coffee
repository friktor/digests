 # Subscribe.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

randomString = require "random-string"

Subscribe =

	# Custom validations
	types: 
		# valid locale {ru || en || pl} without other
		locale: (locale) ->
			/(^ru$|^en$|^pl$)/.test(locale)

	# Attributes field in collection
	attributes: 

		# email for send mails
		
		email: 
			type: "string"
			required: true
			email: true

		# From 
		#	{Hab || Author} - with id source @by field
		# {Newest || Popular} - without source @by field

		from:
			type: "string"
			required: true

		# By {*_id} from {@from field}. 
		# Ignore this field if @from is {Newest || Popular}
		
		by:
			type: "string"
			required: true

		# Locale {locale from code (valid locale) || all}
		
		locale:
			defaultsTo: "ru"
			type: "string"
			locale: true

		# Association for user subscribtions. {user_id || null}
		user:
			model: "user"

		# Enable mailing posts 
		# if @user - can turn off
		# if not @user - only remove

		enableMailing:
			type: "boolean"
			defaultsTo: true

		activated:
			type: "boolean"
			defaultsTo: false
			
	beforeCreate: ($Subscribe, next) ->
		$Subscribe.activateToken = randomString length: 20
		next()
		return

module.exports = Subscribe