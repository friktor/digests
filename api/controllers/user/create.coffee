# @name: create
# @description: create new user with respond activation mail && i18n
# @dependencies: nodemailer, bluebird, i18n
# @params: {username, password, email, firstname, lastname} by POST
# @rest: POST "/utils/user/register"

# List actions.
# 1. Verify Captcha
# 2. Create User
# 3. Response user complete notify
# 4. Send activation mail to email

require "coffee-script/register"

# dependencies
Promise = require "bluebird"
request = Promise.promisify(require("request").post)
readFile = Promise.promisify(require("fs").readFile)
nodemailer = require "nodemailer"
ejs = require "ejs"

# Errors Handler
notValidCaptcha = require "../errors/notValidCaptcha.coffee"
sendError = require "../errors/sendError.coffee"

module.exports = (req, res) ->
	
	params = 
		firstname: req.param "firstname"
		lastname: req.param "lastname"
		username: req.param "username"
		password: req.param "password"
		email: req.param "email"

	reCaptchaSecret = "6LddyQETAAAAAED_fsd1JxaeqT76Yazu2sttaYSt"
	remoteip = req.headers['x-forwarded-for'] || req.connection.remoteAddress
	captcha = req.param "captcha"

	validCaptcha = request("https://www.google.com/recaptcha/api/siteverify", 
		secret: reCaptchaSecret
		remoteip: remoteip
		response: captcha
	).then((recaptcha) -> JSON.parse recaptcha[0].body)

	Promise.join(validCaptcha, (resultVerify) ->
		# switch resultVerify.success
		# 	when false then throw new notValidCaptcha()
		# 	when true then User.create(params)

		sails.log.info resultVerify
		User.create(params)
	)

	# Promised spread with user data and template
	.then((user) -> [
		user
		readFile(sails.config.appPath+"/views/mailTemplates/activation.ejs", "utf-8")
	])

	# send notify with link to activation new user
	.spread((user, template) ->
		transporter = nodemailer.createTransport sails.config.mail # create transporter mail
		
		promisedSendMail = (MailOptions) -> # promised send mail function
			new Promise (resolve, reject) ->
				transporter.sendMail MailOptions, (error, reply) ->
					if error then reject(error) else resolve(reply)
					return
				return

		# options mail
		Mail = 
			subject: req.__ "Activate your new account on Digests.me"
			from: "Digests.me <#{sails.config.mail.auth.user}>"
			to: user.email

			html: ejs.render template,
				link: "http://digests.me/utils/activate?id=#{user.id}&token=#{user.activationToken}"
				title:
					top: req.__ "Welcome"
					bottom: req.__ "Account Activation"
				text: 
					header: req.__ "Congratulations on your registration!"
					main: req.__ "Welcome to our website %s %s! To make full use of your account, you must verify your email address. So you activate your account - and be able to use the full functionality. To do this, click on the appropriate link.", user.firstname, user.lastname
				linkText: req.__ "Activate"

		# Promised send activation mail notify
		responseSendEmail = promisedSendMail(Mail).then (res) -> res

		[user, responseSendEmail]
	)

	# Response user complete notify
	.spread((user, mailResponse) ->
		sails.log.info mailResponse # log response email object

		# Response success: JSON
		res.json
			username: user.username
			success: true
	)

	# Handle not valid captcha error
	.caught(notValidCaptcha, (e) ->
		res.json
			message: req.__ "not valid captcha"
			success: false
	)

	# Handle otherwise errors
	.caught((otherwiseErrors) ->
		sails.log.error otherwiseErrors # log error
		res.json otherwiseErrors # response json with error throw
	)