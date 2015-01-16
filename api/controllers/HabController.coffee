 # HabController
 #
 # @description :: Server-side logic for managing habs
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = {
	
	create: (req, res) ->
		

	index: (req, res) ->

		name = req.param "name"
		return res.notFound() if !name

		Hab.findOne(translitName: name)

		.then((hab) ->
			if hab
				nameHabI18n = _.find hab.name, "locale": req.getLocale()
	
				if nameHabI18n
					nameHabI18n = nameHabI18n.name
				else
					nameHabI18n = hab.translitName
				
				postsInHab = Post.find()
					.paginate({page: req.param("page", 1), limit: 10})
					.sort("createdAt desc")
					.where(hab: hab.id)
					.then (posts) -> posts

				countPostsInHab = Post.count().where(hab: hab.id).then (count) -> count
	
				numberOfSubscribers = Subscribe.count(
					from: "Hab"
					by: hab.id
				).then (count) -> count
	
				[nameHabI18n, hab, postsInHab, numberOfSubscribers, countPostsInHab]
			else
				throw new Error "Hab not found"
			
		)

		.spread((name, hab, posts, countSubscribers, countPostsInHab) ->
			if posts[0] or (!posts[0] and req.param("page", 1) is 1)
				res.view
					title: "#{req.__("Hab")}: #{name} ● #{sails.config.application.name}"
					countSubscribers: countSubscribers
					countPostsInHab: countPostsInHab
					posts: posts
					name: name
					hab: hab

			else 
				throw new Error "Not Found"
					
		)

		.caught((error) ->
			sails.log.error error
			res.notFound()
		)

	list: (req, res) ->
		page = req.param "page", 1

		Hab.find()

		.sort("createdAt desc")

		.paginate(
			page: page
			limit: 10
		)

		.then((habs) ->
			new Promise (resolve, reject) ->
				iterator = (hab, cb) ->
					Subscribe.count({from: "Hab", by: hab.id}).then (count) -> 	
						cb null, _.merge hab, numberOfSubscribers: count
						return
					return

				async.map habs, iterator, (error, habsWithCounter) ->
					if error then reject(error) else resolve(habsWithCounter)
					return
				return
		)

		.then((habs) ->
			if habs[0]
				res.view
					title: "#{req.__("Projects and Habs")} ● #{sails.config.application.name} ● #{page} #{req.__("page")}"
					habs: habs
			else if !habs[0] and req.param("page") isnt 1
				throw new Error "Hab not found"
		)

		.caught((error) ->
			#sails.log.error error
			res.notFound()
		)


	_config: 
		shortcuts: false 
		actions: false 
		rest: false
}
