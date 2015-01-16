Q = require "q"

module.exports = {
	create: (params, options) ->
		deferred = Q.defer()
		options ?= {
			
		};

		Post.create(params).exec (error_create, post) ->
			if error_create
				sails.log.error error_create
				deferred.reject error_create
				return
			else
				deferred.resolve post
				return

		return deferred.promise;
	,

	update: (id, params, options) ->
		deferred = Q.defer()
		options ?= {

		};

		Post.findOne(id: id).exec (error_find, post) ->
			if error_find
				sails.log.error error_find
				deferred.reject error_find
				return
			else
				if post
					Post.update post.id, params, (error_update, posts) ->
						if error_update
							sails.log.error error_update
							deferred.resolve error_update
							return
						else
							deferred.resolve posts[0]
							return
					return
				else
					deferred.reject new Error("Post does not exists")
					return			

		return deferred.promise;
	,

	starred: (params, options) ->
		deferred = Q.defer()
		options ?= {

		};

		# Code

		return deferred.promise;
	,

	to_draft: (params, options) ->
		deferred = Q.defer()
		options ?= {

		};

		# Code

		return deferred.promise;
	,
};