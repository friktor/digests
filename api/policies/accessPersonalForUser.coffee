module.exports = (req, res, next) ->

	res.forbidden() if !req.session.user.username

	if req.session.user.username and req.session.user.username is req.param("username") or req.session.user.admin is true
		next()
	else
		sails.log "is Forbidden: accessPersonalForUser"
		res.forbidden()