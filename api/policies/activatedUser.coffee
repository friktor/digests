module.exports = (req, res, next) ->
	if req.session.auth and (req.session.user.activation is true or req.session.user.admin is true) then next() else 
		res.forbidden()