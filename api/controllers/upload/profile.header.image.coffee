require "coffee-script/register"

# dependencies
fse = require "fs-extra"
Download = require "download"
Promise = require "bluebird"
async = require "async"
map = Promise.promisify(async.map)

# Common and Utils
utils = require "../../services/Utils.coffee"
common = require "./common.coffee"

# errors classes
notExists = require "../errors/notExists.coffee"

gm = require("gm").subClass imageMagick: true

module.exports = (req, res) ->
	username = req.param "username"

	User.findOneByUsername(username).populate("headingImg")

	.then((user) ->
		if !user then throw new notExists "User not found" else

			if user.headingImg.length > 0
				asyncRemoveHeading = ->
					new Promise (resolve, reject) ->
						iterator = (img, cb) ->
							fse.removeSync img.absolutePath
							File.destroy img.id, (err, file) -> cb()
							return

						async.each user.headingImg, iterator, (error) ->
							if error then reject(error) else resolve(true)
							return
						return

				destroyed = asyncRemoveHeading().then (status) -> status

				[user.toObject(), destroyed]
			else
				[user.toObject()]
	)

	.spread((user, status) ->
		UploadedImage = common.UploadImage(req.file("imageFile"), "/personal/#{user.username}/headingImg/source").then (image) -> image
		[user, UploadedImage]
	)

	.spread((user, image) ->
		if !image then throw new Error "Image not found" else
			workDir = sails.config.upload.dir+"/personal/"+user.username+"/headingImg"
			resizedImages = common.resizeUserHeadingImages(image.filedisk, workDir).then ($images) -> $images
			[user, resizedImages]
	)

	.spread((user, images) ->
		if !images then throw new Error "Images resized not exists or found" else
			
			workDir = sails.config.upload.dir+"/personal/#{user.username}/headingImg"
			fullImageFiledisk = _.find(images, "restrict": "full")

			cropNavbarBgAndForming = common.cropAndBlurNavbarBg(fullImageFiledisk.filedisk, workDir)
				.then (navbarBgImage) -> 
					images.push navbarBgImage
					return images

			[user, cropNavbarBgAndForming]
	)

	.spread((user, images) ->

		if !images then throw new Error "Images not resized" else

			iteratorCreateRecord = (image, cb) ->
				$file = 
					link: image.filedisk.replace sails.config.upload.serve, ""
					absolutePath: image.filedisk
					filename: image.filename
					restrict: image.restrict
					mime: image.filetype
					size: image.filesize
					headingImg: user.id
					activated: true
				File.create $file, (error, file) ->
					cb error, file
					return
				return

			recordsImages = map(images, iteratorCreateRecord).then ($files) -> $files

			[user, recordsImages]
	)

	.spread((user, filesImages) ->
		res.json
			filesImages: filesImages
			user: user
	)

	.catch((error) ->
		sails.log.error error
		res.json error
	)