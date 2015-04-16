require "coffee-script/register"

# dependencies
nodemailer = require "nodemailer"
bcrypt = require "bcrypt-nodejs"
Promise = require "bluebird"
ejs = require "ejs"

readFile = Promise.promisify(require("fs").readFile)

# Errors Handler
notExists = require "../errors/notExists.coffee"
sendError = require "../errors/sendError.coffee"

module.exports = (req, res) ->
	username = req.param "username" # target user
	password = req.param "password" # new password

	User.findOneByUsername(username).then((user) ->
		if !user then throw new notExists() else
			template = readFile(sails.config.appPath+"/views/mailTemplates/notifyPassword.ejs", "utf-8")
			updatedUser = User.update(username: user.username, 
				hashedPassword: bcrypt.hashSync password
				password: password
			).then (updated) -> updated[0]

			[updatedUser, template]
	)

	.spread((user, template) ->
		transporter = nodemailer.createTransport sails.config.mail

		promisedSendNotifyUpdatePassword = (options) ->
			new Promise (resolve, reject) ->
				transporter.sendMail options, (error, reply) ->
					if error then reject(error) else resolve(reply)
					return
				return

		Mail = 
			subject: req.__ "You have changed the password Digests.me"
			from: "Digests.me <#{sails.config.mail.auth.user}>"
			to: user.email

			html: ejs.render template, 
				subheader: req.__ "You have successfully updated the password"
				header: req.__ "Notify"
				text: req.__ "Hello %s %s. This letter is to inform about the fact that you have updated your password on the website. Your new password:", user.firstname, user.lastname
				password: password


		[user, promisedSendNotifyUpdatePassword(Mail)]
	)

	.spread((user, replyMail) ->
		res.json
			user: user.username
			# mail: replyMail
			success: true
	)

	.caught(notExists, (e) ->
		res.badRequest()
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)