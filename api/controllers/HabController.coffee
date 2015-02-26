 # HabController
 #
 # @description :: Server-side logic for managing habs
 # @help	:: See http://links.sailsjs.org/docs/controllers

require "coffee-script/register"

module.exports =

	habs: require "./hab/habs.coffee"
	
	publicList: require "./hab/serealizedList.coffee"

	byhab: require "./hab/postsByHab.coffee"

	habsList: require "./hab/listHabs.coffee"

	_config: 
		shortcuts: false 
		actions: false 
		rest: false