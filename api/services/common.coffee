async = require "async"
Q = require "q"

module.exports = {

	GetOne: ($Model, options) ->
		deferred = Q.defer()

		options ?= {}

		$Model.findOne(options).exec (error_find, data) ->
			if error_find
				sails.log.error error_find
				deferred.reject error_find
				return
			else
				deferred.resolve data
				return

		return deferred.promise;
	,
			
	List: ($Model, options, paginate) ->
		deferred = Q.defer()

		$Model
			.find(options)
			.paginate(paginate)
			.exec ($error, $data) ->
				if $error
					deferred.reject($error)
				else
					deferred.resolve($data)

		return deferred.promise;
	,

	Count: ($Model, options) ->
		deferred = Q.defer()

		Count = (_model_, cb) ->
		  _model_.count(options).exec(cb)
		
		if Utils.type($Model) is "array"
			async.mapSeries $Model, Count, (err, result) ->
				if err
					deferred.reject(err)
				else
					deferred.resolve(result)

		else
			$Model.count(options).exec (error, result) ->
				if error
					deferred.reject(error)
				else
					deferred.resolve(result)				
			
		return deferred.promise;
		
}