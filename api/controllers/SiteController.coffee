module.exports = 
	homepage: (req, res) ->
		res.view "homepage",
			title: req.__ "Digests.me Homepage"
			description: req.__ "My digests - is an independent international blogging platform. Our mission is to provide you with a platform to Express their thoughts and ideas."

	about: (req, res) ->
		res.view
			title: req.__ "About us"

	recovery: (req, res) ->
		res.view 
			title: req.__ "Recovery Account"
			
	_config: 
		shortcuts: false 
		actions: false 
		rest: false