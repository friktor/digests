Promise = require "bluebird"
fse = require "fs-extra"

removeFile = Promise.promisify fse.remove

module.exports = 
	index: (req, res) ->

		# @target - avatar, heading img, etc..
		target = req.param "target"
		# @username - find query
		username = req.param "username"
		# @same file from requiest
		file = req.file "file"
		
		if !file or !username or !target then res.serverError()

		User.findOneByUsername(username).populate(target)

		.then((user) ->
			if !user then res.forbidden() else
				# @remove record & file if exists
				if Utils.type(user[target]) isnt "undefined" 
					sails.log "Avatar #{user.username} is exists"
					Promise.join user, removeFile(user[target].absolutePath), File.destroy(user[target].id), (user) -> user
				else user
		)

		.then((user) ->
			
			if target is "avatarImg"
				dirname = "#{sails.config.upload.dir}/personal/#{user.username}/avatar"
			else if target is "headingImg"
				dirname = "#{sails.config.upload.dir}/personal/#{user.username}/headingImg"

			new Promise (resolve, reject) ->
				file.upload dirname: dirname, (error, uploaded) ->
					
					serveReplace = sails.config.upload.serve
					file = uploaded[0]
					
					recordDb = 
						filename: file.filename
						absolutePath: file.fd
						mime: file.type
						size: file.size
						link: file.fd.replace serveReplace, ""
			
					recordDb[target] = user.id			
			
					resolve [
						user
						File.create(recordDb)
					]
					
		)

		.spread((user, file) ->
			
			user[target] = file.id
			user.save()

			# if req.session.user.username is username then req.session.user = user.toObject()
			# sails.log req.session.user

			res.json
				user: user.toJSON()
				target: target
				success: true
				file: file	
		)

		.caught (error) ->
			sails.log.error error
			res.serverError() 

	_config: 
		shortcuts: false 
		actions: false 
		rest: false