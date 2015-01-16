 # Hab.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs				:: http://sailsjs.org/#!documentation/models

Hab =

	attributes:

		headingImg:
		  type: "string"
		  required: true
	
		name: 
			type: "array", # [{locale: "en", name: "Programming"}, {locale: "ru", name: "Программирование"}...]
			required: true
	
		description: 
			type: "array" # [{locale: "en", desc: "Test description"}, {locale: "ru", desc: "Тестовое описание"}]
			required: true
	
		tags:
			type: "array" # Example: ["tag1", "tag2"] 
			required: true
			defaultsTo: []
	
		subscribers: 
			type: "array" 
			defaultsTo: [] # Example: ["_uuid", etc....]

	beforeCreate: ($Hab, next) ->
		# find name on english
		en = _.find $Hab.name, "locale": "en"

		# If find = set translit version from en name
		if en
			$Hab.translitName = en.name
		else
			# else - set name from transit name version any lang
			$Hab.translitName = require('transliteration')( 

				(_.first($Hab.name)).name 
			)

		next()
		
		

module.exports = Hab;