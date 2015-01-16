 # Comment.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

Comment =

  attributes: {
		
		author: { # Id author
			model: "user"
		},

		message: { # main message string
			type: "string", 
			required: true
		},

		reply: {
			type: "array", # reply for comment, Example: [{author: "_uuid", message: "@message"}, etc...]
			defaultsTo: [], 
		},

		post: {
			type: "string", # post uuid
			required: true,
		},

		rating: {
			type: "integer", # rating for comment (Test field)
			defaultsTo: 0,
		},
  }

Comment.beforeCreate = ($Comment, next) ->
  next()

module.exports = Comment;
