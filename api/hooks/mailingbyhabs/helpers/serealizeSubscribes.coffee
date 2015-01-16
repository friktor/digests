nodemailer = require "nodemailer"
Promise = require "bluebird"
async = require "async"
_ = require "lodash"

module.exports = (subscribes) ->
	new Promise (resolve, reject) ->
		serealized = []

		iterator = (subscribe, next) ->
			if subscribe.activated isnt true then next() else
				index = _.findIndex serealized, "hab_id": subscribe.by

				if (index isnt null) and (index isnt -1)
					indexLocale = _.findIndex(
						serealized[index].recipients,
						"locale": subscribe.locale
					)
					array[index].recipients[indexLocale].emails.push(subscribe.email)
					next()
				else
					serealizeObject =
						hab_id: subscribe.by
						recipients: [
							locale: "ru", emails: []
						,
							locale: "en", emails: []
						,
							locale: "pl", emails: []
						,
						]

					indexLocale = _.findIndex serealizeObject.recipients, "locale", subscribe.locale
					serealizeObject.recipients[indexLocale].emails.push(subscribe.email)
					serealized.push(serealizeObject)
					next()
			return

		async.each subscribes, iterator, (error) ->
			if error then reject(error) else resolve(serealized)
			return