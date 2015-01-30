# FS
fse = require "fs-extra"
fs = require "fs"

gm = require("gm").subClass imageMagick: true
randomString = require "random-string"

module.exports = (imageSize, workDir, filepath, cb) ->
	filename = "#{randomString(length: 8)}.full.jpg"
	filedisk = "#{workDir}/#{filename}"
	
	gm(filepath).resize(1600).crop(1600, 350, 0, 450).autoOrient().write filedisk, (error) ->
		$image = 
			filesize: (fs.statSync(filedisk)).size
			filetype: "image/jpeg"
			filedisk: filedisk
			filename: filename
			restrict: "full"

		cb(error, $image)
		return
	return