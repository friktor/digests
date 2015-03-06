 # UserController
 #
 # @description :: Server-side logic for managing users
 # @help        :: See http://links.sailsjs.org/docs/controllers

require "coffee-script/register"

module.exports =

	# @See "api/controllers/user/verifyExists.coffee"
	existsUser: require("./user/verifyExists.coffee").existsUser

	# @See "api/controllers/user/verifyExists.coffee"
	existsEmail: require("./user/verifyExists.coffee").existsEmail

	# @See "api/controllers/user/create.coffee"
	create: require "./user/create.coffee"

	# @See "api/controllers/user/activate.coffee"
	activate: require "./user/activate.coffee"

	# @See "api/controllers/user/update.coffee"
	update: require "./user/update.coffee"

	# @See "api/controllers/user/update.coffee"
	updatePassword: require "./user/updatePassword.coffee"

	# @See "api/controllers/user/recoveryAccount.coffee"
	recoveryAccount: require "./user/recoveryAccount.coffee"
 
	_config: 
		shortcuts: false 
		actions: false 
		rest: false