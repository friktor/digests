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
	transporter = nodemailer.createTransport sails.config.mail
	email = req.param "email"

	User.findOneByEmail(email).then((user) ->
		if !user then throw new notExists() else
			template = readFile(sails.config.appPath+"/views/mailTemplates/notifyPassword.ejs", "utf-8")
			[user, template]
	)

	.spread((user, template) ->
		promisedSendNotify = (options) ->
			new Promise (resolve, reject) ->
				transporter.sendMail options, (error, reply) ->
					if error then reject(error) else resolve(reply)
					return
				return

		Mail =
			subject: req.__ "You have requested information to log on to the website Digests.me"
			from: "Digests.me <#{sails.config.mail.auth.user}>"
			to: user.email
			html: ejs.render template, 
				text: req.__ "You have requested the password from your account on the digests.me. Your password:"
				subheader: req.__ "Account access"
				header: req.__ "Notify"
				password: user.password

		[user, promisedSendNotify(Mail)]
	)

	.spread((user, reply) ->
		res.json success: true
	)

	.caught(notExists, (e) ->
		res.json
			throw: "user not exists"
			success: false
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)