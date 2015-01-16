module.exports = (req, res, next) ->
	
	sails.io.on "connect", (socket) ->
		if req.session.auth and req.session.user and req.session.user.online is false
			User.findOneByUsername req.session.user.username, (error, user) ->
				if user
					user.online = true
					user.save()
				return
		return

	next()