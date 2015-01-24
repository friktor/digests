 # ProfileController
 #
 # @description :: Server-side logic for managing profiles
 # @help        :: See http://links.sailsjs.org/docs/controllers

require "coffee-script/register"
Promise = require "bluebird"

module.exports =

	index: require "./profile/profile.coffee"

	addpost: require "./profile/addpost.coffee"

	edit: require "./profile/edit.coffee"

	settings: require "./profile/settings.coffee"

	subscription: require "./profile/subscription.coffee"

	_config: 
		shortcuts: false 
		actions: false 
		rest: false