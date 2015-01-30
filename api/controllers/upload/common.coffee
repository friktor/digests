require "coffee-script/register"

# Common and Utils
utils = require "../../services/Utils.coffee"

# errors classes
notExists = require "../errors/notExists.coffee"

# dependencies
require "coffee-script/register"

# FS
fse = require "fs-extra"
fs = require "fs"

# Download, Bluebird, Caman Image
Download = require "download"
Promise = require "bluebird"
gm = require("gm").subClass imageMagick: true

randomString = require "random-string"
readChunk = require "read-chunk"
fileType = require "file-type"
async = require "async"

focusCrop = require("../../services/fc.coffee").crop

# Errors
badFileType = require "../errors/badFileType.coffee"


module.exports = 


	# @params: {filepath|stringFilepath, workDir|stringFilePath}
	# @descriptions: function for resize profile header images. After complete - preview blured image & full image.

	resizeUserHeadingImages : (filepath, workDir) ->

		new Promise (resolve, reject) ->
			existsFile = fs.existsSync filepath # exists this images
			existsWorkDir = fs.existsSync workDir # exists work dir

			if !existsWorkDir then fs.mkdirSync workDir # mkdir workDir if not exists
			
			if !existsFile then throw new Error "File not exists" else # if not file - throw error
				# Get images size resolution
				gm(filepath).size (error, imageSize) ->

					# if error by getsize - hanndle reject error
					if error then reject(error) else
						resizeImagePreview = require "./resizeProfileHeading/resizeSidebarImage.coffee" #iterator create preview blured image
						resizeFullImage = require "./resizeProfileHeading/resizeImageFull.coffee" # iterator resize full images

						# async parallel event resized images
						# partials functions with requided params
						async.parallel [ 
							_.partial(resizeImagePreview, imageSize, workDir, filepath)
							_.partial(resizeFullImage, imageSize, workDir, filepath)
						] , (error, $images) ->
							# After event - remove source images
							fse.removeSync filepath
							# resolve event result
							if error then reject(error) else resolve($images)
							return
					return
			return



	# @params: {sourceFile|filePath, workDir|filePath, optionsImg|array}
	# @descriptions: function for resize images. After complete - preview images, full images.
	# @{param:optionsImg|array} Example: [{restrict: "full", width: 1000}, {restrict: "preview", width: 350}]

	ResizeImages: (sourceFile, workDir, optionsImg) ->
		new Promise (resolve, reject) ->
			exists = fs.existsSync(sourceFile) # exists file - true or false
			existsWorkDir = fs.existsSync(workDir) #exists work dir

			if !existsWorkDir then fs.mkdirSync(workDir) # mkdir workDir if not exists

			if !exists then throw new Error "File not exists" else
				
				iteratorResize = (optImg, cb) ->
					format = if optImg.format then optImg.format else "jpg"
					filetype = if format is "png" then "image/png" else "image/jpeg"
					
					nameImage = "#{randomString(length: 10)}.#{optImg.restrict}.#{format}" # image name.
					saveAsTo = "#{workDir}/#{nameImage}" # save to with filename

					# Resize image using image-magick with auto orientation.
					gm(sourceFile)
						.resize(optImg.width).autoOrient()
						.write saveAsTo, (error) ->
							cb error,
								filesize: (fs.statSync(saveAsTo)).size #size file 
								restrict: optImg.restrict #image restrict
								filename: nameImage #image filename
								filedisk: saveAsTo #image absolutepath
								filetype: filetype #image type

							return
					return

				async.map optionsImg, iteratorResize, (error, files) ->
					fse.removeSync(sourceFile) # clean source image
					if error then reject(error) else resolve(files)
					return
			return



	# @params: {file|reqFileObject, filepath|dirpath}
	# @descriptions: promised function for upload new image with validate.

	UploadImage: (file, filepath) ->
		new Promise (resolve, reject) ->
			saveDirSrc = sails.config.upload.dir+filepath
	
			file.upload dirname: saveDirSrc, (error, uploaded) ->
				if error then reject(error) else
					uploadImage = uploaded[0]

					if !(uploadImage.type in ["image/png", "image/jpeg"])
						fse.removeSync(uploadImage.fd) # sync remove file
						reject new badFileType("This is not valid image")
					else
						resolve
							filename: uploadImage.filename
							filetype: uploadImage.type
							filesize: uploadImage.size
							filedisk: uploadImage.fd
							uploadfd: true
					return
			return



	# @params: {link|httpLinkToImage, postNumericId|dirname}
	# @descriptions: promised function for download new image with validate.

	DownloadImageFromLink : (link, postNumericId) ->
		new Promise (resolve, reject) ->

			# Reject error if not defined required params
			if !link or !postNumericId then throw new Error "Not defined 'link' or 'postNumericId'" else

				# dir for save file
				saveDirSrc = sails.config.upload.dir+"/post/"+postNumericId+"/headerImg/source"
	
				# new instance for download file
				DownloadLink = new Download(mode: "755")
					.dest(saveDirSrc)
					.get(link)
	
				# Run download task
				DownloadLink.run (error, files, stream) ->
					# reject error if error isnt null
					if error 
						reject(error)
						return
					else
	
						filename = (fs.readdirSync(saveDirSrc))[0]  #read file source dir, and slice filename 
						filedisk = saveDirSrc+"/"+filename # full path to file
						filetype = fileType(readChunk.sync(filedisk, 0, 262)) # parse filetype from buffer.
						filesize = (fs.statSync(filedisk)).size # size this file
	
						# If image is not valid image mime - remove file and reject
						if !(filetype.mime in ["image/png", "image/jpeg"])
							fse.removeSync(filedisk) # sync remove file
							reject new badFileType("This is not valid image")
						else
							# If all valid resolve data
							resolve
								filename: filename
								filedisk: filedisk
								filetype: filetype
								filesize: filesize
								fromlink: true
						return
				return