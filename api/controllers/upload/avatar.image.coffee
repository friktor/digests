require "coffee-script/register"

# dependencies
fse = require "fs-extra"
Download = require "download"
Promise = require "bluebird"
async = require "async"
_ = require "lodash"

# Common and Utils
utils = require "../../services/Utils.coffee"
common = require "./common.coffee"

# errors classes
notExists = require "../errors/notExists.coffee"

gm = require("gm").subClass imageMagick: true

module.exports = (req, res) ->

	username = req.param "username"

	User.findOneByUsername(username).populate("avatarImg")

	.then((user) ->
		if !user then throw new notExists "User not found" else
			if user.avatarImg.length > 0
				asyncRemoveAvatarImages = ->
					new Promise (resolve, reject) ->
						iterator = (image, cb) ->
							File.destroy image.id, (error) ->
								fse.removeSync image.absolutePath
								cb error, true

						async.map user.avatarImg, iterator, (error, $destroyed) ->
							if error then reject(error) else resolve(true)
							return
						return

				destroyed = asyncRemoveAvatarImages().then (status) -> status

				[user, destroyed]
			else
				[user]
	)

	.spread((user, status) ->
		saveToDirname = "/personal/#{user.username}/avatarImg/source"
		uploadedImage = common.UploadImage(req.file("imageFile"), saveToDirname).then (image) -> image

		[user, uploadedImage]
	)

	.spread((user, image) ->
		if !image then throw new Error "image not found" else
			workDir = "#{sails.config.upload.dir}/personal/#{user.username}/avatarImg"
			optionsImg = [{restrict: "full", width: 120, format: "png"}, {restrict: "preview", width: 80, format: "png"}]
			resizedImages = common.ResizeImages(image.filedisk, workDir, optionsImg).then (images) -> images

			[user, resizedImages]
	)

	.spread((user, images) ->
		if !images then throw new Error "images resized not found" else
			
			asyncCreateFileRecords = ->
				new Promise (resolve, reject) ->
					iterator = (image, cb) ->
						$file =
							link: image.filedisk.replace sails.config.upload.serve, ""
							absolutePath: image.filedisk
							restrict: image.restrict
							filename: image.filename
							mime: image.filetype
							size: image.filesize
							avatarImg: user.id

						File.create $file, (error, file) ->
							cb error, file
							return
						return

					async.map images, iterator, (error, $files) ->
						if error then reject(error) else resolve($files)
						return
					return

			FileRecords = asyncCreateFileRecords().then (files) -> files

			[user, FileRecords]
	)

	.spread((user, FileRecords) ->
		res.json
			avatar: FileRecords
			user: user
	)

	.caught((error) ->
		sails.log.error error
		res.json error
	)