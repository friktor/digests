nodemailer = require "nodemailer"
Promise = require "bluebird"
async = require "async"
_ = require "lodash"

module.exports = (sails, habs) ->

	new Promise (resolve, reject) ->

		iteratorHab = (hab, cb) ->

			iteratorSendRecipients = (recipient, cbRec) ->
				template = _.find hab.rendered, "locale": recipient.locale

				if (_.size(recipient.emails) is 0) or !template then cbRec() else
					transporter = nodemailer.createTransport sails.config.mail
	
					mail =
						subject: "Digests by your Habs. Today"
						from: "#{sails.config.app.host.toUpperCase()} <#{sails.config.mail.auth.user}>"
						to: _(recipient.emails).join ", "
						html: template.html
	
					transporter.sendMail mail, (e, notify) ->
						cbRec e, notify
						return
					return 
	
			async.map hab.recipients, iteratorSendRecipients, (error, notify) ->
				cb error, notify
				return
			return

		async.map habs, iteratorHab, (error, notify) ->
			if error then reject(error) else resolve(notify)
			return 
		return