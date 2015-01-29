require "coffee-script/register"

# dependencies
fse = require "fs-extra"
Download = require "download"
Promise = require "bluebird"
Caman = require("caman").Caman

# Common and Utils
utils = require "../../services/Utils.coffee"
common = require "./common.coffee"

# errors classes
notExists = require "../errors/notExists.coffee"

module.exports = (req, res) ->
	
	uploadType = req.param "uploadType" # link to image file, or upload request
	postId = req.param "postId" # id for link to post

	imageLink = req.param "imageLink"

	Post.findOne(postId).populate("headerImg").then((post) ->
		if !post then throw new notExists "Post not exists" else post.toObject()
	)

	.then((post) ->
		if post.headerImg.length > 0
			
			# promised function for async destroy exists images, and record from db
			PromisedDestroyImages = ->
				new Promise (resolve, reject) ->
					# async eacj all header images
					async.each post.headerImg, (img, next) ->
						fse.removeSync img.absolutePath # remove images
						File.destroy img.id, (error, file) -> next() #destroy from db
						return
					, (errors) ->
						# Resolve promised status complete
						if errors then reject(errors) else resolve(true)
						return
					return

			# Run complete destroy task (promised)
			completeDestroy = PromisedDestroyImages().then (status) -> status
			# promised spread
			[post, completeDestroy]
		else
			# spread empty
			[post]
	)

	.spread((post, completeDestroy) ->
		# if uploadType is "link"
		if uploadType is "link"
			downloadedImage = common.DownloadImageFromLink(imageLink, post.numericId).then (fileSource) -> fileSource
			[post, downloadedImage]
		# if uploadType is "upload"
		else if uploadType is "upload"
			uploadedImage = common.UploadImage(req.file("image"), post.numericId).then (fileSource) -> fileSource
			[post, uploadedImage]
		# if another uploadType
		else throw new Error "Not defined required params"
	)

	.spread((post, Image) ->

		if !Image then throw new Error "Image not exists" else
			workDir = sails.config.upload.dir+"/post/"+post.numericId+"/headerImg" # set work dir path

			# Options for resize images
			optionsImage = [{
				restrict: "full"
				width: 1000
			}, {
				restrict: "preview"
				width: 360
			}]

			# Promised variable images resized
			resizedImages = common.ResizeImages(Image.filedisk, workDir, optionsImage).then (images) -> images

			# Promised spread with params
			[post, resizedImages]
	)

	.spread((post, images) ->

		if !images then throw new Error "Images resized not exists" else
			iteratorCreateRecordToDb = (image, cb) ->
				$file = 
					absolutePath: image.filedisk
					restrict: image.restrict
					postHeaderImage: post.id
					filename: image.filename
					mime: image.filetype
					size: image.filesize
					link: image.filedisk.replace sails.config.upload.serve, ""
	
				File.create($file).exec (error, file) ->
					cb error, file
					return
				return
	
			promisedAsyncCreateRecordFileWithImage = ->
				new Promise (resolve, reject) ->
					async.map images, iteratorCreateRecordToDb, (error, records) ->
						if error then reject(error) else resolve(records)
						return
					return
	
			headerImages = promisedAsyncCreateRecordFileWithImage().then (files) -> files
	
			[post, headerImages]
	)

	.spread((post, parsedImages) ->
		# Response json after upload.
		res.json
			images: parsedImages
			success: true
	)