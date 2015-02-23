require "coffee-script/register"

# dependencies
Promise = require "bluebird"
common  = require "./common.coffee"
async = require "async"

# Promisify
map = Promise.promisify(async.map)

# Errors
notExists = require "../errors/notExists.coffee"

`Array.prototype.uniqueObjectArray = function(field) {
    var processed = [];
    for (var i=this.length-1; i>=0; i--) {
        if (this[i].hasOwnProperty(field)) {
            if (processed.indexOf(this[i][field])<0) {
                processed.push(this[i][field]);
            } else {
                this.splice(i, 1);
            }
        }
    }
}`

module.exports = (req, res) ->

	id = req.session.user.id
	
	page = try
		parseInt(req.param("page", 1))
	catch e
		1

	Subscriptions = Subscribe.find(user: id).then (subscriptions) -> subscriptions
	Signer = User.findOne(id).then (user) -> user

	Promise.join(Signer, Subscriptions, (signer, subscriptions) ->
		if !signer or !subscriptions then throw new notExists "User or Subscriptions not found" else
			byAuthor = [] # tape id interesting authors
			byHabs = [] # tape id interesting habs

			# Each subscribes for forming array with tape
			subscriptions.forEach (subscribe, index) ->
				switch subscribe.from
					when "Author" then byAuthor.push author: "contains": subscribe.by
					when "Hab" then byHabs.push hab: "contains": subscribe.by
				return

			# Clean duplicate
			byAuthor = common.arrayUnique(byAuthor)
			byHabs = common.arrayUnique(byHabs)

			[byHabs, byAuthor] # return promised spread
	)

	.spread((habs, authors) ->
		sort = "createdAt desc"
		
		paginate = 
			limit: 25
			page: page

		PostsFromAuthor = Post.find().populate("headerImg").where(or: authors).sort(sort).paginate(paginate).then (posts) -> posts
		PostsFromHabs = Post.find().populate("headerImg").where(or: habs).sort(sort).paginate(paginate).then (posts) -> posts

		[PostsFromHabs, PostsFromAuthor]
	)

	.spread((fromHabs, fromAuthors) ->
		renderedPostsFromAuthor = map(fromAuthors, common.renderPost).then (rendered) -> rendered
		renderedPostsFromHabs = map(fromHabs, common.renderPost).then (rendered) -> rendered

		[renderedPostsFromHabs, renderedPostsFromAuthor]
	)

	.spread((habsPosts, authorsPosts) ->
		mergePosts = habsPosts.concat authorsPosts # merge authors posts & habs posts
		mergePosts.uniqueObjectArray "id" # clean all posts by duplicate - id

		if mergePosts.length is 0 then res.notFound() else

			target =
				title: req.__("My personal feed")+" · Digests.me · "+req.__("%s page", page)
				locale: req.getLocale()
				posts: mergePosts
				page: page
	
			switch req.param("ajax", "otherwise")
				when "true" then res.json target
				else res.view target

	)

	.error((error) ->
		sails.log.error error
		res.serverError()
	)