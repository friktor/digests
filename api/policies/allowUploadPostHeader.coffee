module.exports = (req, res, next) ->
	id = req.param "postId"

	Post.findOne(id).then (post) ->
		if !post then res.forbidden() else
			if (post.id is req.session.user.id) or req.session.user.admin is true
				next()
			else res.forbidden()

	return