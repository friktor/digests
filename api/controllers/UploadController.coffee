require "coffee-script/register"

Promise = require "bluebird"
fse = require "fs-extra"

removeFile = Promise.promisify fse.remove

module.exports =

	uploadPostHeaderImages: require "./upload/post.header.images.coffee"

	# _config: 
	# 	shortcuts: false 
	# 	actions: false 
	# 	rest: false