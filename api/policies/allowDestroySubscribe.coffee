module.exports = (req, res, next) ->
	Subscribe.findOne(req.param("id")).exec (error, subscribe) ->
		if (subscribe and (subscribe.user is req.session.user.id)) or req.session.user.admin is true
			next()
		else
			res.forbidden()
		return
	return