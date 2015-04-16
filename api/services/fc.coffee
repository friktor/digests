# Focus crop function
# @param {String} filename Source filename
# @param {Array} foucs Focus point coordinates [x,y]
# @param {Array} resize Destination resize dimensions [w, h]
#  
# Cropping algorithm:
# 1) calculate destionation proprtion
#  k = Wr/Hr
# 2) define max image size that will fit current image
#  if Wr >= Hr: Wm = Wi, Hm = Wi/k
#   else Hm = Hi, Wm = Hm*k
# 3) calculate new focus point coordinates
#   fx2 = fx*Wm/Wi, 
#   fy2 = fy*Hm/Hi
# 4) Perform crop offset and dimensions as max image size
#  crop(Wm, Hm, (fx-fx2), (fy-fy2))
# 5) Resize to destination format
#   resize(Wr, Hr)

Promise = require "bluebird"

Gm = require("gm").subClass
	imageMagick: true

crop = (filepath, saveAsPath, focus, resize, blur = [0,0]) ->

	new Promise (resolve, reject) ->

		image = Gm(filepath).noProfile()
	
		image.size (error, size) ->
			if error then reject(error)
	
			k = resize.width/resize.height
			Wm = size.width
			Hm = Math.round Wm/k 
		
			if Hm > size.height
				Wm = Math.round size.height*k
				Hm = size.height
			
			fx2 = Math.round focus[0]*Wm/size.width
			fy2 = Math.round focus[1]*Hm/size.height
		
			image.crop Wm, Hm, focus[0]-fx2, focus[1]-fy2
			image.resize resize.width, resize.height, "!"
			image.blur blur[0], blur[1]
		
			image.sharpen 1
			
			image.write saveAsPath, (error) ->
				if error then reject error else resolve saveAsPath
				return
			return
		return
	

module.exports =
	crop: crop