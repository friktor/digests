# dependencies
Promise = require "bluebird"

md = require("../../post/common.coffee").markdown
_ = require "lodash"
xss = require "xss"


module.exports = (comment) ->
	new Promise (resolve, reject) ->
		User.findOne(comment.author).populate("avatarImg").exec (error, user) ->
			
			renderMessage = (message) ->
				xss md.render(message),
					whiteList: sails.config.xss
					stripIgnoreTag: false
	
			avatars = _.find(user.avatarImg, "restrict": "preview")
	
			author = 
				firstname: user.firstname
				username: user.username
				lastname: user.lastname
				avatars: avatars.link or false
		
			if error then reject(error) else resolve _.merge comment, 
				message: renderMessage(comment.message)
				author: author
			return
		return