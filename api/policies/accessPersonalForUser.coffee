module.exports = (req, res, next) ->
	sessionUsername = req.session.user.username ? ""
	if (sessionUsername and (sessionUsername is req.param("username", "UndiefineD"))) or req.session.user.admin is true
		next()
	else
		res.forbidden()
	