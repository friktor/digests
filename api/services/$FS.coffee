fse = require "fs-extra"
Q = require "q"

remove = (path) ->
	deferred = Q.defer()

	fse.remove path, (error) ->
		if error
			deferred.reject error
		else
			deferred.resolve true
		return
		
	deferred.promise;

module.exports = 
	remove : remove
	delete : remove