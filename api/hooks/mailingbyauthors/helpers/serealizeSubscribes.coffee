Promise = require "bluebird"
async = require "async"
_ = require "lodash"

module.exports = (subscribes) ->

	new Promise (resolve, reject) ->

		### Refractor ###
		serealized = []
	
		iterator = (subscribe, next) ->
			index = _.findIndex serealized, "author_id": subscribe.by
	
			if subscribe.activated isnt true then next() else
			
				if (index isnt null) and (index isnt -1)
					serealized[index].recipients.push(subscribe.email) 
					next()
				else
					
					serealizeObject = 
						author_id: subscribe.by
						recipients: []
		
					serealizeObject.recipients.push subscribe.email
					serealized.push(serealizeObject)
					next()
	
		async.each subscribes, iterator, (error_iteration) ->
			resolve(serealized)
			return