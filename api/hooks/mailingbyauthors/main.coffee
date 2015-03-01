cron = require("cron").CronJob;
require "coffee-script"

module.exports = (sails) ->
	
	serealizeSubscribes      : require "./helpers/serealizeSubscribes.coffee"
	asyncRenderPostsByAuthor : _.partial require("./helpers/asyncRenderPostsByAuthor.coffee"), sails
	asyncFindPostsByAuthors  : _.partial require("./helpers/asyncFindPostsByAuthors.coffee"), sails
	sendMailToRecipients     : _.partial require("./helpers/sendMailToRecipients.coffee"), sails
	
	respond: _.partial require("./respond.coffee"), sails

	initialize: (cb) ->
		sails.log.info "hooks:mailingbyauthors:loaded"

		Hook = @

		weeklyMailingByAuthors = new cron
			timeZone: "Europe/Moscow"
			cronTime: "0 0 0 * * 0" # @weekly
			start: false
			onTick: ->
				Hook.respond().then (notify) ->
					sails.log notify
					return
				return

		# weeklyMailingByAuthors.start()
		cb()