module.exports = (req, res, next) ->
	sessionUsername = req.session.user.username
	if (sessionUsername and (sessionUsername is req.param("username"))) or req.session.user.admin is true
		next()
	else
		sails.log "is Forbidden: accessPersonalForUser"
		res.forbidden()
	