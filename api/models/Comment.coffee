 # Comment.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

Comment =
	attributes:

		# @author: "string". Association with user model.
		author:
			required: true 
			model: "user"

		# @message: "string". Content message with comment
		message:
			type: "string"
			required: true
			maxLength: 300

		# @reply: "bool". This comment is reply to comment?
		reply:
			type: "boolean"
			defaultsTo: false

		# @replyTarget: "string". Id target reply comment.
		replyTarget:
			type: "string"

		# @target: "string". Target for list comment. Post id, page and other...
		target:
			type: "string"
			required: true

module.exports = Comment;