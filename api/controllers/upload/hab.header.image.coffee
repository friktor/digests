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

module.exports = (req, res) ->
	habId = req.param "habId"

	Hab.findOne(habId).populate("headingImg").then((hab) ->
		if !hab then throw new notExists() else hab.toObject()
	)
	
	.then((hab) ->
		if hab.headingImg.length > 0
			iteratorDestroy = (image, cb) ->
				File.destroy image.id, (error) ->
					fse.removeSync image.absolutePath
					cb error, true
					return
				return

			completeDestroy = map(hab.headingImg, iteratorDestroy).then (status) -> status
			[hab, completeDestroy]
		else
			[hab]
	)

	.spread((hab, statusDestroyExists) ->
		saveDirPath = "/habs/#{hab.translitName}/headingImg/source"
		uploadedImage = common.UploadImage(req.file("image"), saveDirPath).then (file) -> file
		[hab, uploadedImage]
	)

	.spread((hab, image) ->
		if !image then throw new Error "Image not upload" else
			workDir = sails.config.upload.dir+"/habs/#{hab.translitName}/headingImg"

			optionsResize = [{
				restrict: "full"
				width: 1600
			}, {
				restrict: "preview"
				width: 500
			}]

			resizedImages = common.ResizeImages(image.filedisk, workDir, optionsResize).then (images) -> images

			[hab, resizedImages]
	)

	.spread((hab, images) ->
		if !images then throw new Error "Images resized not exists or found" else
			
			workDir = sails.config.upload.dir+"/habs/#{hab.translitName}/headingImg"
			fullImageFiledisk = _.find(images, "restrict": "full")

			cropNavbarBgAndForming = common.cropAndBlurNavbarBg(fullImageFiledisk.filedisk, workDir)
				.then (navbarBgImage) -> 
					images.push navbarBgImage
					return images

			[hab, cropNavbarBgAndForming]
	)

	.spread((hab, images) ->
		if !images then throw new Error "Images resized not exists or found" else

			iteratorCreateRecord = (image, cb)->
				$file = 
					link: image.filedisk.replace sails.config.upload.serve, ""
					absolutePath: image.filedisk
					imagesize: image.imgsizes
					restrict: image.restrict
					filename: image.filename
					projectImage: hab.id
					mime: image.filetype
					size: image.filesize
					activated: true

				File.create($file).exec (error, file) ->
					cb error, file
					return
				return

			headingImages = map(images, iteratorCreateRecord).then (images) -> images

			[hab, headingImages]
	)

	.spread((hab, images) ->
		res.json
			images: images
			success: true
	)

	.caught((error) ->
		sails.log.error error
		res.serverError()
	)