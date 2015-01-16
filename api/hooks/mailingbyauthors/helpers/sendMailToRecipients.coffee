nodemailer = require "nodemailer"
Promise = require "bluebird"
async = require "async"
_ = require "lodash"

module.exports = (sails, authors) ->
	new Promise (resolve, reject) ->
		transporter = nodemailer.createTransport sails.config.mail

		iterator = (author, cb) ->
			if (!author or author.recipients.length <= 0) then cb() else
				mail = 
					from: "#{sails.config.app.host.toUpperCase()} <#{sails.config.mail.auth.user}>"
					to: _(author.recipients).join ", "
					subject: author.title
					html: author.html

				transporter.sendMail mail, (error, reply) ->
					cb error, reply
					return
			return

		async.map authors, iterator, (errors, results) ->
			if errors then reject(errors) else
				resolve results
			return
		return