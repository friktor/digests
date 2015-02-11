 # HabController
 #
 # @description :: Server-side logic for managing habs
 # @help        :: See http://links.sailsjs.org/docs/controllers

require "coffee-script/register"

module.exports = {
	
	publicList: require "./hab/serealizedList.coffee"

	_config: 
		shortcuts: false 
		actions: false 
		rest: false
}
