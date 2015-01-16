Promise = require "bluebird"
readFile = Promise.promisify require("fs").readFile

module.exports = (sails) ->
	Hook = this

	sails.models.subscribe.find()

	.where(from: "Author")
	.sort(createdAt: "desc")

	.then(Hook.serealizeSubscribes)
	.then(Hook.asyncFindPostsByAuthors)
	
	.then((authors) ->
		mailTemplate = readFile("#{sails.config.appPath}/views/mailTemplates/responder.ejs", "utf-8").then (ejs) -> ejs
		[authors, mailTemplate]
	)

	.spread(Hook.asyncRenderPostsByAuthor)

	.then(Hook.sendMailToRecipients)

	.then (notify) -> notify