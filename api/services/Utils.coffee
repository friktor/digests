fs = require "fs"
Q = require "q"

module.exports = {
	type : (obj) ->
	    if obj == undefined or obj == null
	      return String obj
	    classToType = {
	      '[object Boolean]': 'boolean',
	      '[object Number]': 'number',
	      '[object String]': 'string',
	      '[object Function]': 'function',
	      '[object Array]': 'array',
	      '[object Date]': 'date',
	      '[object RegExp]': 'regexp',
	      '[object Object]': 'object'
	    }
	    return classToType[Object.prototype.toString.call(obj)]
	,
	readFile: (path) ->
		deferred = Q.defer()

		fs.readFile "#{templatePath}#{template}", encoding: "utf-8", ($err_read, file) ->
			if $err_read or !file
				deferred.reject $err_read, "File does not exists, or other error fs" # @(err, stack)
				return
			else
				deferred.resolve file
				return

		return deferred.promise;
	,
	defer: (fn) ->
		setTimeout(fn, 0)		
};