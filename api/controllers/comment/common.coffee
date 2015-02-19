require "coffee-script/register"

# dependencies
Promise = require "bluebird"

md = require("../post/common.coffee").markdown
map = Promise.promisify(require("async").map)
_ = require "lodash"
xss = require "xss"

module.exports =
	
	asyncCommentsWithReply : (comment, cb) ->
		Render = require "./common/renderComment.coffee"

		renderedComment = Render(comment).then (rendered) -> rendered
		replyComment = Comment.find({reply: true, replyTarget: comment.id})
			.then((replyArray) ->
				iterator = (reply, cb) ->
					Render(reply).then (renderedReply) -> 
						cb null, renderedReply
						return
					return

				replyArray = map(replyArray, iterator).then (renderedReplyMap) -> renderedReplyMap
			)
			.then (reply) -> 
				reply

		Promise.join(renderedComment, replyComment, (comment, reply) ->
			cb null, _.merge comment, 
				reply: reply
			return
		)

		.caught((error) ->
			sails.log.error error
			return
		)
		return
