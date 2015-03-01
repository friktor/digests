cron = require("cron").CronJob;
require "coffee-script"

module.exports = (sails) ->
	serealizeSubscribes    : require("./helpers/serealizeSubscribes.coffee")
	sendMailToRecipients   : _.partial require("./helpers/sendMailToRecipients.coffee"), sails
	asyncFindPostsByHabs   : _.partial require("./helpers/asyncFindPostsByHabs.coffee"), sails
	asyncRenderPostsByHabs : _.partial require("./helpers/asyncRenderPostsByHabs.coffee"), sails

	respond : _.partial require("./respond.coffee"), sails

	initialize: (cb) ->
		sails.log.info "hooks:mailingbyhabs:loaded"
		Hook = @

		weeklyMailingByHabs = new cron
			timeZone: "Europe/Moscow"
			cronTime: "0 0 0 * * 0" # @weekly
			start: false
			onTick: ->
				Hook.respond().then (notify) ->
					sails.log notify
					return
				return

		# weeklyMailingByHabs.start()		
		cb()