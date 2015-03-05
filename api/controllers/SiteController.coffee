module.exports = 
	homepage: (req, res) ->
		res.view "homepage",
			title: req.__ "Digests.me Homepage"

	about: (req, res) ->
		res.view
			title: req.__ "About us"
			
	_config: 
		shortcuts: false 
		actions: false 
		rest: false