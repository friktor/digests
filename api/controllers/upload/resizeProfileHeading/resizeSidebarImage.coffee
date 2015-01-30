# FS
fse = require "fs-extra"
fs = require "fs"

focusCrop = require("../../../services/fc.coffee").crop
gm = require("gm").subClass imageMagick: true
randomString = require "random-string"

module.exports = (imageSize, workDir, filepath, cb) ->
	focus = [(imageSize.width/3), (imageSize.height/4)]
	filename = "#{randomString(length: 8)}.sidebar.jpg"
	filedisk = "#{workDir}/#{filename}"

	focusCrop(filepath, filedisk, focus, {height: 170, width: 280}, [9, 5]).then (saveFilename) ->
		$image = 
			filesize: (fs.statSync(filedisk)).size
			filetype: "image/jpeg"
			filedisk: filedisk
			filename: filename
			restrict: "sidebar"

		cb(null, $image)
		return