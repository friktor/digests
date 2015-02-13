 # Hab.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs				:: http://sailsjs.org/#!documentation/models

translit = require('transliteration')

Hab =

	attributes:

		# @HeadingImg: "array".
		# assiciations
		headingImg:
		  collection: "file"
		  via: "projectImage"
	
		
		# @Name: "array".
		# Example: [{ locale: '$locale', name: '$name'}]
		name: 
			required: true
			type: "array"
	
		
		# @Description: "array". 
		# Example: [{ locale: '$locale', desc: '$description' }]
		description: 
			required: true
			type: "array"
	
		
		# @Tags: "string". 
		# Example "tag1, tag2, tag3"
		tags: "string"
	
		
		# @Type: "string". 
		# Variations: global or locale.
		type:
			defaultsTo: "local"
			type: "string"

		
		# @Project "boolean".
		# type habs 
		project:
			type: "boolean"
			defaultsTo: false


	beforeCreate: ($Hab, next) ->
		# find name on english
		en = _.find $Hab.name, "locale": "en"

		# If find = set translit version from en name
		if en then $Hab.translitName = en.name else $Hab.translitName = translit((_.first $Hab.name).name)

		# Callback
		next()		

module.exports = Hab;