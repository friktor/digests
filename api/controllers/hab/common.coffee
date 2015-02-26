module.exports = 
	iteratorForming: (locale, restrictImg, hab, cb) ->

		desc = _.find(hab.description, "locale": locale)
		name = _.find(hab.name, "locale": locale)
		imageHeading = _.find(hab.headingImg, "restrict": restrictImg)
		navbarBg = _.find(hab.headingImg, "restrict": "navbarBg")

		cb null, _.merge hab, 
			name: name.name or hab.translitName
			description: desc.desc or null
			headingImg: false
			headingImage: try
				size: imageHeading.imagesize
				link: imageHeading.link
			catch e
				false
			navbarImage: navbarBg.link 
		return