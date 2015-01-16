Promise = require "bluebird"
readFile = Promise.promisify require("fs").readFile

module.exports = (sails) ->
	Hook = @

	sails.models.subscribe.find()
	
	.where(from: "Hab")

	.then(Hook.serealizeSubscribes)
	.then(Hook.asyncFindPostsByHabs)
	
	.then((withPosts) ->
		mailTemplate = readFile("#{sails.config.appPath}/views/mailTemplates/responder.ejs", "utf-8")
		[withPosts, mailTemplate]
	)
	
	.spread(Hook.asyncRenderPostsByHabs)

	.then(Hook.sendMailToRecipients)

	.then((notify) -> notify)