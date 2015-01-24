module.exports = (req, res) ->
	id = req.param "id"

	# If not param id response badRequst
	if !id then res.badRequest()

	# Main params
	postForUpdate =
		headerImg: req.param "header_img"
		content : req.param "content"
		author  : req.param "author"
		locale  : req.param "locale"
		title   : req.param "title"
		draft   : req.param "draft"
		tags    : req.param "tags" 
		hab     : req.param "hab"

	Post.findOne(id)

	.then((post) ->
		if !post then req.badRequest() else
			# Update post
			Post.update(post.id, post).then (post) ->
				# Publish update pubsub for socket.io
				Post.publishUpdate post[0].id,
					locale: post.locale
					title: post.title
					id: post.id 
				# Return promised post
				return post[0]
	)

	.then((post) ->
		res.json
			success: true
			post: post
	)

	.caught (error) ->
		sails.log.error error
		res.serverError()