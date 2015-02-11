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

		size: 
			type: "integer"
			required: true

		postHeaderImage:
			model: "post"

		activated: 
			type: "boolean"
			defaultsTo: false


###
Associations
###

#@ Profile avatar image
File.attributes.avatarImg  = model: "user"

#@ Profile header image
File.attributes.headingImg = model: "user"

#@ Post header image

module.exports = File;