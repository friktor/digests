module.exports =
	existsUser: (req, res) ->
		username = req.param "username"

		if !username then res.badRequest() else
			User.findOneByUsername(username).then((user) ->
				if user then res.json(exists: true) else res.json exists: false
			).error (error) -> res.serverError()


	existsEmail: (req, res) ->
		email = req.param "email"

		if !email then res.badRequest() else

			User.findOneByEmail(email).then((user) ->
				if user then res.json(exists: true) else res.json(exists: false)
			).error (error) -> res.serverError()