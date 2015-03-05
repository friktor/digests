module.exports = (req, res, next) ->
	res.forbidden() if !req.session.auth
	if ((req.param("username") and req.session.user.username) and (req.param("username") is req.session.user.username)) or req.session.user.admin is true
		next()
	else res.forbidden()
	