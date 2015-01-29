 # UserController
 #
 # @description :: Server-side logic for managing users
 # @help        :: See http://links.sailsjs.org/docs/controllers

nodemailer = require "nodemailer"
bcrypt = require "bcrypt-nodejs"
Promise = require "bluebird"
ejs = require "ejs"

readFile = Promise.promisify require("fs").readFile

# Send Error
class sendError extends Error
	constructor: (@message) ->
		@name = "sendError"
		Error.captureStackTrace(this, sendError)

module.exports = {

	# @name: create
	# @description: create new user with respond activation mail && i18n
	# @dependencies: nodemailer, bluebird, i18n
	# @params: {username, password, email, firstname, lastname} by POST
	# @rest: POST "/utils/user/register"

	create: (req, res) ->

		# Params for new user
		params = 
			username: req.param "username"
			password: req.param "password"
			email: req.param "email"

			firstname: req.param "firstname"
			lastname: req.param "lastname"

		User.create(params)

		.then((user) ->
			# read template file for mail
			[user, readFile("#{sails.config.appPath}/views/mailTemplates/activation.ejs", "utf-8")]
		)

		.spread((user, template) ->
			# Create transport
			transport = nodemailer.createTransport sails.config.mail

			# options mail
			mailOptions = 
				from: "#{sails.config.app.host.toUpperCase()} <#{sails.config.mail.auth.user}>"
				to: user.email

				subject: req.__ "Activate your new account on {{website}}",
					website: sails.config.application.name

				# Render html mail from locale, template
				html: ejs.render template,
					link: "#{sails.config.application.url}/utils/activate?id=#{user.id}&token=#{user.activationToken}"
					text: req.__ "Welcome to our website {{firstname}} {{lastname}}! To make full use of your account, you must verify your email address. So you activate your account - and be able to use the full functionality. To do this, click on the appropriate link.",
						firstname: user.firstname
						lastname: user.lastname
					linkText: req.__ "Activate"

			# Send mail from options
			transport.sendMail mailOptions, (errorSend, reply) ->
				if errorSend # if error - throw send mail error
					throw new sendError "error send activation mail"
				else
					[user, reply]
		)

 		# promise spread user data, reply data
		.spread((user, reply) ->
			res.json
				complete: true
		)

		# Handle send mail error
		.caught(sendError, (e) ->
			sails.log.error e
			res.json
				complete: true				
		)

		# Handle othrwise error
		.caught((e) ->
			sails.log.error e
			res.json 
				complete: false
		)

	# @name: activate
	# @description: activate user account
	# @dependencies: nodemailer, bluebird, i18n
	# @params: {id, token} by GET
	# @rest: GET "/utils/activate"

	activate: (req, res) ->
		token = req.param "token"
		id = req.param "id"

		User.findOne().where(id: id)

			.then((user) ->
				if user
					user
				else
					res.badRequest()
			)

			.then((user) ->
				if user.activationToken is token
					user.activation = true
					user.save()

					res.view "200"
				else
					res.badRequest()
			)

	# @name: update
	# @description: update info for user
	# @dependencies: nodemailer, bluebird, i18n
	# @params: {username, [params]} by POST
	# @rest: GET "/utils/user/update"

	update: (req, res) ->

		username = req.param "username"

		res.badRequest() if !username

		User.findOneByUsername(username)

		.then((user) ->
			if user
				params = 
					activitiesMe: req.param "activitiesMe", user.activitiesMe
					firstname: req.param "firstname", user.firstname
					lastname: req.param "lastname", user.lastname
					aboutMe: req.param "aboutMe", user.aboutMe
				
				[user, params]
			else
				throw new Error "user does not exists"
		)

		.spread((user, params) ->
			User.update(user.id, params)
		)

		.then((updatedUser) ->
			user = updatedUser[0]

			res.json
				message: req.__ "Personal information updated!"
				success: true
				user: user
		)

		.caught((e) ->
			sails.log.error e
			res.badRequest()
		)



	# @name: activate
	# @description: activate user account
	# @dependencies: nodemailer, bluebird, i18n
	# @params: {id, token} by GET
	# @rest: GET "/utils/activate"

	updatePassword: (req, res) ->
		username = req.param "username"
		newpass = req.param "newpass"

		res.badRequest() if (!username or !newpass)

		# Find User
		User.findOneByUsername(username)

		# Change password
		.then((user) ->
			if user
				updated =
					hashedPassword : bcrypt.hashSync newpass
					password : newpass

				[User.update(user.id, updated), readFile("#{sails.config.appPath}/views/mailTemplates/notify_password.ejs", "utf-8")]
			else
				throw new Error "user does exists"
		)

		# Message to user.email
		.spread((users, template) ->
			transport = nodemailer.createTransport sails.config.mail
			user = users[0]

			mailOptions =
				from: "#{sails.config.app.host.toUpperCase()} <#{sails.config.mail.auth.user}>"
				to: user.email

				subject: req.__ "You have successfully updated your password on {{website}}",
					website: sails.config.application.name

				html: ejs.render template,
					text: req.__ "Your new password on the site - {{password}}",
						password: user.password

			# Send notification message
			transport.sendMail mailOptions, (errorSend, reply) ->
				if errorSend
					sails.log.error errorSend
					throw new sendError "send mail for change password error"
				else
					sails.log reply
					reply
		)

		# Response success after change pass and send mail
		.then((reply) ->
			# sails.log reply
			res.json 
				complete: true
				message: req.__ "Password is changed!"
		)

		# Handle send mail error
		.caught(sendError, (e) ->
			sails.log.error e
			return
		)

		# Handle otherwise error
		.caught (e) ->
			sails.log.error e
			res.serverError()
 

	# _config: 
	# 	shortcuts: false 
	# 	actions: false 
	# 	rest: false
		
}
