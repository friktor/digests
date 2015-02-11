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
Promise = require "blurbird"
request = Promise.promisify(require("request").post)
readFile = Prmise.promisify(require("fs").readFile)
nodemailer = require "nodemailer"

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

	request("https://www.google.com/recaptcha/api/siteverify", 
		secret: reCaptchaSecret
		remoteip: remoteip
		response: captcha
	)

	.then((response) ->
		data = JSON.parse response.body # parse response
		# if success promise next, else if not success throw error
		if !data.success then throw new notValidCaptcha() else true
	)

	# create new user
	.then((successCaptcha) ->
		User.create(params)
	)

	# Promised spread with user data and template
	.then((user) -> [
		user
		readFile("../../../views/mailTemplates/activation.ejs", "utf-8")
	])

	# send notify with link to activation new user
	.spread((user, template) ->
		transporter = nodemailer.createTransport sails.config.mail # create transporter mail
		promisedSendMail = Promise.promisify(transporter.sendMail) # promised send mail function

		# options mail
		Mail = 
			subject: req.__ "Activate your new account on Digests.me"
			from: "Digests.me <#{sails.config.mail.auth.user}>"
			to: user.email

			html: ejs.render template,
				link: "http://digests.me/utils/activate?id=#{user.id}&token=#{user.activationToken}"
				text: req.__ "Welcome to our website %s %s! To make full use of your account, you must verify your email address. So you activate your account - and be able to use the full functionality. To do this, click on the appropriate link.", user.firstname, user.lastname
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