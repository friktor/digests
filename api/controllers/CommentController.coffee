 # CommentController
 #
 # @description :: Server-side logic for managing comments
 # @help        :: See http://links.sailsjs.org/docs/controllers

require "coffee-script/register"

module.exports = 
	create: require "./comment/create.coffee"
	remove: require "./comment/remove.coffee"
	# update: require "./comment/update.coffee"
	get   : require "./comment/get.coffee"

	_config: 
		shortcuts: false 
		actions: false 
		rest: false