Promise = require "bluebird"
async = require "async"

# Error class for handle promise
notExists = require "../errors/notExists.coffee"
map = Promise.promisify(async.map)


module.exports = (req, res) ->
	username = req.param "username"

	switch req.param "ajax"
		when "true"
			User.findOneByUsername(username).then((user) ->
				if !user then throw new notExists() else
					subscriptions = Subscribe.find(user: user.id).sort("createdAt desc").then (subscriptions) -> subscriptions
					[user, subscriptions]
			)
		
			.spread((user, subscriptions) ->
				iterator = (subscription, cb) ->
					delete subscription.activateToken
		
					switch subscription.type
						when "hab"
							Hab.findOne(subscription.purpose).populate("headingImg").exec (error, hab) ->
								headingImg = _.find(hab.headingImg, "restrict": "preview").link
								cb error, _.merge subscription, purpose:
									image: headingImg 
									link: "/hab/#{hab.translitName}"
									header: try
										_.find(hab.name, "locale": req.getLocale()).name
									catch e
										hab.translitName
									# Description hab by locale
									description: try
										_.find(hab.description, "locale": req.getLocale()).desc.substr(0, 150)+"..."
									catch e
										_.find(hab.description, "locale": "en").desc.substr(0, 150)+"..."							
								return
									 
						when "author"
							User.findOne(subscription.purpose).populate("avatarImg").exec (error, user) ->
								cb error, _.merge subscription, purpose:
									header: "#{user.firstname} #{user.lastname}"
									link: "/profile/#{user.username}"
									description: "this is author"
									image: try
										_.find(user.avatarImg, "restrict": "preview").link
									catch e
										"/images/avatar.png"
								return
					return
		
				formedSubscriptions = map(subscriptions, iterator).then (subscriptions) -> subscriptions
				[user, formedSubscriptions]
			)
		
			.spread((user, subscriptions) ->
				res.json 
					subscriptions: subscriptions
					user: user
			)
			
		else res.view title: req.__("My subscriptions")+" · Digests.me"