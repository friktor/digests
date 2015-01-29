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
ImageMagick = require "gm"

randomString = require "random-string"
readChunk = require "read-chunk"
fileType = require "file-type"
async = require "async"

# Errors
badFileType = require "../errors/badFileType.coffee"


module.exports = 

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
					nameImage = "#{randomString(length: 10)}.#{optImg.restrict}.jpg" # image name.
					saveAsTo = "#{workDir}/#{nameImage}" # save to with filename

					# Resize image using image-magick with auto orientation.
					ImageMagick(sourceFile).options(imageMagick: true)
						.resize(optImg.width).autoOrient()
						.write saveAsTo, (error) ->
							cb error,
								filesize: (fs.statSync(saveAsTo)).size #size file 
								restrict: optImg.restrict #image restrict
								filename: nameImage #image filename
								filedisk: saveAsTo #image absolutepath
								filetype: "image/jpeg" #image type

							return
					return

				async.map optionsImg, iteratorResize, (error, files) ->
					fse.removeSync(sourceFile) # clean source image
					if error then reject(error) else resolve(files)
					return
			return



	# @params: {file|reqFileObject, postNumericId|dirname}
	# @descriptions: promised function for upload new image with validate.

	UploadImage: (file, postNumericId) ->
		new Promise (resolve, reject) ->
			saveDirSrc = sails.config.upload.dir+"/post/"+postNumericId+"/headerImg/source"
	
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