Promise = require "bluebird" 

notExists = require "../errors/notExists.coffee"

module.exports = (req, res) ->
	comment = req.param "comment"
	author = req.param "author"

	$comment = Comment.findOne(comment).then (comment) -> comment
	$author = User.findOneByUsername(author).then (user) -> user

	Promise.join($comment, $author, (comment, author) ->
		if !comment or !author then throw new notExists() else [comment, author]
	)

	.spread((comment, author) ->
		destroyComment = Comment.destroy(comment.id).then (destroyed) -> destroyed
		
		destroyReply = Comment.destroy(
			replyTarget: comment.id
			reply: true
		).then (destroyed) -> destroyed

		[destroyComment, destroyReply]
	)

	.spread((comment, reply) ->
		res.json
			comment: comment.id
			success: true
	)

	.caught(notExists, (error) ->
		res.json
			success: false
			throw: "not exists: author or comment"
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)