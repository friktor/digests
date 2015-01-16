Promise = require "bluebird"
nodemailer = require "nodemailer"
ejs = require "ejs"

readFile = Promise.promisify require("fs").readFile

# Send Error
class sendError extends Error
	constructor: (@message) ->
		@name = "sendError"
		Error.captureStackTrace(this, sendError)

module.exports = 
	subscribeCreate: (options) ->
		new Promise (resolve, reject) ->
			transport = nodemailer.createTransport sails.config.mail

			readFile("#{sails.config.appPath}/views/mailTemplates/default.ejs", "utf-8")

			.then((template) ->
				Mail = 
					subject : sails.__
						phrase: "Please activate your subscribe on Digests.me"
						locale: options.locale

					from: "#{sails.config.app.host.toUpperCase()} <#{sails.config.mail.auth.user}>"
					to: options.email

					html: ejs.render template,
						text: "" + (sails.__(
						  phrase: "Please activate your subscribe on Digests.me. For activate - click to link «Activate»."
						  locale: options.locale
						)) + "\n <a href=\"#{sails.config.app.url}/utils/subscribe/activate?id=" + options.id + "&#38;token=" + options.token + "\">" + sails.__({phrase: "Activate", locale: options.locale}) + "</a>"

				transport.sendMail Mail, (error_send, reply) ->
					if error_send
						reject error_send
					else
						sails.log.info reply
						resolve reply
					return
				return
			) 

			.caught (e) ->
				sails.log.error e
				return
