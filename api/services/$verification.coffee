Q = require "q"

module.exports = {
	user: (options) ->
		deferred = Q.defer()

		User.findOne(id: options.id)
		
		.exec (error, user) ->
			if error
				deferred.reject(error)
			else
				if user
					if options.token is user.activationToken
						user.activation = true;
						user.save()
		
						deferred.resolve(true)
					else 
						deferred.resolve(false)
				else
					deferred.resolve(false)
			
		return deferred.promise;
	,


};