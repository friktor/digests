module.exports = (req, res, next) ->
	if (req.param("author") is req.session.user.username) or req.session.user.admin is true
		next()
	else res.forbidden()
