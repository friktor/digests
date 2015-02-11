module.exports = (req, res, next) ->

	if req.session.auth is true and req.session.user.activation is true
		next()
	else
		res.forbidden()