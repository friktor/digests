nodemailer = require "nodemailer"
Promise = require "bluebird"
i18n = require "i18n"
ejs = require "ejs"


transporter = nodemailer.createTransport sails.config.mail
readFile = Promise.promisify(require("fs").readFile)

module.exports = 
	sendMailAfterCreateSubscribe: (params) ->
		new Promise (resolve, reject) ->
			# Defaults configurations i18n/
			i18n.configure sails.config.i18n
			# Set locale language from params
			i18n.setLocale params.locale

			# Template mail
			template = readFile(sails.config.appPath+"/views/mailTemplates/activationSubscribe.ejs", "utf-8").then (tmpl) -> tmpl

			# Try promised find data - 'author' or 'habs'
			data = Promise.try ->
				switch params.type
					when "author" 
						User.findOne(params.purpose).populate("headingImg").populate("avatarImg")
					when "hab"
						Hab.findOne(params.purpose).populate("headingImg")
		
			# Promise join template and data/
			Promise.join(template, data, (template, data) ->
				switch params.type
					when "author"

						# Set name for mail
						name = data.firstname+" "+data.lastname
						
						# Find heading Image - try find, or set default / From User heading
						headerImage = try
							(_.find(data.headingImg, "restrict": "full")).link
						catch e
							"/images/mail/defaultHeader.jpg"

						# Mini logo try find, or set default/ From User avatar 
						miniLogoImage = try
							(_.find(data.avatarImg, "restrict": "full")).link
						catch e
							"/images/logo.png"
					
					when "hab"

						# Set name for mail
						name = try
							(_.find(data.name, "locale": params.locale)).name
						catch e
							data.translitName
						

						# Find heading Image - try find, or set default / From Hab heading
						headerImage = try
							(_.find(data.headingImg, "restrict": "full")).link
						catch e
							"/images/mail/defaultHeader.jpg"

						# In hab set default digests.me logo image/
						miniLogoImage = "/images/logo.png"

				Mail = 
					subject: i18n.__("Please activate your subscription on %s", name)+" · Digests.me"
					from: "Digests.me <#{sails.config.mail.auth.user}>"
					to: params.email

					html: ejs.render template, 
						link: "http://digests.me/utils/subscribe/activate?id=#{params.id}&#38;token=#{params.activateToken}"
						miniLogoImage: miniLogoImage
						headerImage: headerImage
						name: name
						message:
							main: i18n.__ "Hello user! This letter notifies you that your subscription was successfully created. But it starts to work and you could regularly receive alerts about new interesting things you have to activate it. To activate a subscription - simply click on the \"Activate\" button."
							disclaimer: i18n.__ "If you have not signed up on our website and this letter has come to you by chance - just ignore it."
							activate: i18n.__ "Activate"
							type: i18n.__ params.type

				transporter.sendMail Mail, (error, reply) ->
					if error then reject error else resolve reply
					return
				return
			)

			.caught((error) ->
				sails.log.error error
				return
			)