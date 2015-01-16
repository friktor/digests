 # File.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs				:: http://sailsjs.org/#!documentation/models

File = 

	# identity: "file"

	attributes:

		filename:
			required: true
			type: "string"

		absolutePath: 
			type: "string"
			required: true

		mime:
			type: "string"
			required: true

		meta: # Example: {for: "post", _uuid: "@id"}
			type: "object"
			required: false

		size: 
			type: "integer"
			required: true 

###
Ассоциации
###

#@ Профиль аватар изображение
File.attributes.avatarImg  = model: "user"

#@ Профиль шапка изображение
File.attributes.headingImg = model: "user"

module.exports = File;