module.exports = (req, res, next) ->
	if req.session.auth and (req.param("author") is req.session.user.id or req.session.user.admin is true) then next() else
		res.forbidden req.__ "You dont activate account."