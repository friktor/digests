 # AuthController
 #
 # @description :: Server-side logic for managing auths
 # @help        :: See http://links.sailsjs.org/docs/controllers
bcrypt = require "bcrypt-nodejs"

module.exports = 
	
	login: (req, res) ->
		title = req.__ "Login"
		res.view
			title: title

	register: (req, res) ->
		title = req.__ "Register"

		res.view 
			title: title

	auth: (req, res) ->
		username = req.param "username"
		password = req.param "password"

		User.findOne()

		.populate("headingImg")
		.populate("avatarImg")

		.where(or: [{
				username: username
			}, {
				email: username
		}])

		.then((user) ->
			# sails.log "User #{user.username} is exists\n"
			if !user
				res.json
					status: false
					user: null
				return
			
			else user
		)

		.then((user) ->
			isMatch = bcrypt.compareSync password, user.hashedPassword
			# sails.log "is match: #{isMatch}\n"

			if !isMatch
				res.json
					status: false
					user: null
				return
			else
				req.session.user = user
				req.session.auth = true

				user.online = true
				
				user.save (error, user) ->
					User.publishUpdate user.id, 
						username: user.username
						action: "has logged in"
						id: user.id

					res.json
						user: user.toJSON()
						status: true
					return
				return
		)
		return


	logout: (req, res) ->
		url = req.param "url", "/"

		if req.session.user.id
			User.findOne(req.session.user.id).then (user) ->
				if user
					req.session.destroy()
					user.online = false
					
					user.save (error, user) ->
						User.publishUpdate user.id,
							username: user.username
							action: "is logout"
							id: user.id

						res.redirect url
				else req.session.destroy()
				return
		else
			res.redirect "/"
		return

	settingLocale: (req, res) ->
		locale = req.param("locale", "ru")
		res.cookie("locale", locale)

		res.redirect "/"

	_config: 
		shortcuts: false 
		actions: false 
		rest: false
