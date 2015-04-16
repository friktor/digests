 # PostController
 #
 # @description :: Server-side logic for managing posts
 # @help        :: See http://links.sailsjs.org/docs/controllers

require "coffee-script/register"

module.exports = 

	# See "api/controllers/post/create.coffee"
	create: require "./post/create.coffee"

	# See "api/controllers/post/popular.coffee"
	popular: require "./post/popular.coffee"

	# See "api/controllers/post/details.coffee"
	details: require "./post/details.coffee"

	# See "api/controllers/post/latest.coffee"
	latest: require "./post/latest.coffee"

	# See "api/controllers/post/tapePersonal.coffee"
	tapePersonal: require "./post/tapePersonal.coffee"

	# See "api/controllers/post/byauthor.coffee"
	byauthor: require "./post/byauthor.coffee"

	# See "api/controllers/post/byauthor.coffee"
	update: require "./post/update.coffee"

	# Config for this controller
	_config: 
		shortcuts: false 
		actions: false 
		rest: false
