 # CommentController
 #
 # @description :: Server-side logic for managing comments
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = {
	create: (req, res) ->
		params =
			author: req.param "author"
			message: req.param "message"
			post: req.param "post"

		Comment.create(params)

		.then((comment) ->
			res.json 
				complete: true
				comment: comment
		)

		.caught((error) ->
			sails.log.error error
			res.badRequest()
		)

	_config: 
		shortcuts: false 
		actions: false 
		rest: false
}
