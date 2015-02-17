# dependencies
Promise = require "bluebird"
request = Promise.promisify(require("request").post)

# Errors Handler
notValidCaptcha = require "../errors/notValidCaptcha.coffee"

module.exports = (req, res) ->

	reCaptchaSecret = "6LddyQETAAAAAED_fsd1JxaeqT76Yazu2sttaYSt"
	remoteip = req.headers['x-forwarded-for'] || req.connection.remoteAddress
	captcha = req.param "captcha"

	verifyCaptcha = request("https://www.google.com/recaptcha/api/siteverify", 
		secret: reCaptchaSecret
		remoteip: remoteip
		response: captcha
	)

	.then((response) ->
		data = JSON.parse response.body
		data.success
	)

	Promise.join(verifyCaptcha, (validResponse) ->
		if !validResponse then throw new notValidCaptcha() else
			params = 
				replyTarget: req.param "replyTarget"
				message: req.param "message"
				author: req.param "author"
				target: req.param "target"
				reply: req.param "reply"

			Comment.create(params)
	)

	.then((comment) ->
		author = User.findOneById(comment.author).populate("avatarImg").then (user) -> user
		[comment, author]
	)

	.spread((comment, author) ->
		comment.author = author
		res.json comment
	)

	.caught(notValidCaptcha, (e) ->
		res.forbidden("not valid recaptcha")
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)