module.exports = 
	homepage: (req, res) ->
		res.view "homepage",
			title: "Digests.me Homepage"

	about: (req, res) ->
		res.view
			title: req.__ "About us"
			text: req.__ '''Digests.me is an international independent collective blog. The aim of the project is to create a convenient platform for the expression of their thoughts, and to share experiences in various fields.<br>Digests.me - this is a project which can be interesting to a large number of persons without limitations as to the language barrier or lack of areas of creativity and activity.<br>On our project, you can keep your personal blog or a collection of thematic information (hub) - which together with other bloggers and readers is sorted and a variety of tape information which is accessible to all.<br>At the moment the site is fully or partially translated into 3 languages: Russian, Polish, English. This is only the beginning. But even now you can get the most diverse and interesting information which is provided only by us.<br>On the website there are a few basic concepts:<br><br>Hub - a set of information branches or separate direction than in either. According to the idea there are several types of branching - global and local.<br>* Local: the branch from the mainstream, for example Impressionism is the local direction from the main branch of the Art.<br>* Global: the main large for the invariant direction or complex monolithic information chain. For example, you can call the global hub Programming - which in turn can be divided into a number of separate local branches. Even global hubs are local soprovojdeniye other hubs.<br>* Project - the concept of the local hub distinctive feature of which is independent of the direction which can develop one group of people to explain their thoughts.<br><br>At the moment the site is in alpha mode. At this point, you can write your blog in hubs that are already built on the site. Until such work is unstable functions as an independent branch and the Association of local and global hubs. There is no possibility to use several global branches to select the direction of entry, but at the moment this problem is solved by using the tags.'''
			
	_config: 
		shortcuts: false 
		actions: false 
		rest: false