nodemailer = require "nodemailer"
aejs = require "async-ejs"
async = require "async"
ejs = require "ejs"
fs = require "fs"
Q = require "q"

module.exports = {
	send: (data, auth, options, template) ->
		deferred = Q.defer()
		templatePath = "#{sails.config.appPath}/views/mailTemplates/"

		template ?= "default.ejs"
		auth ?= sails.config.mail
		data ?= {}

		if !options or Utils.type(options) isnt "object"
			deferred.reject new Error("Dont enter required options or options isnt object")
			return
		else
			transport = nodemailer.createTransport auth

			if Utils.type(options.to) is "array"
				options.to = _(options.to).join(',')
				return
			
			aejs.renderFile "#{templatePath}#{template}", data, (err_render, compiled) ->
				if err_render
					deferred.reject err_render
					return
				else
					options.html = compiled;
					options.from = "#{sails.config.app.host.toUpperCase()} <#{sails.config.mail.auth.user}>"
					transport.sendMail options, (error_send, reply) ->
					  if error_send
					  	deferred.reject error_send
					  	return
					  else
					  	deferred.resolve reply
					  	return

		return deferred.promise;
}