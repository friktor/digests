module.exports = (req, res, next) ->
	res.forbidden() if !req.session.auth
	if (req.param("user") and req.param("user") is req.session.user.id) or req.session.user.admin is true
		next()
	else res.forbidden()