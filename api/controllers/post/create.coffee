#@action: create
#@description: create new post in DB
#@params:	{content: contentMarkdown}, 
#					{locale: language_posts}, 
#					{headingImage: link},
#					{author: author_id}, 
#					{title: title}, 
#					{hab: hab_id array string, "id_1, id_2, etc.."}

#@dependencies: defaults {{none}}

Promise = require "bluebird"
async = require "async"

module.exports = (req, res) ->
	post = 
		# Main param
		author  : req.param "author"      # author (associations_id)
		content : req.param "content"     # content main
		markLang: req.param "markLang"
		locale  : req.param "locale"      # language post
		title   : req.param "title"       # title post
		hab     : req.param "habs"        # hab array (via ,)
		tags    : req.param "tags"        # tags
		
		# Locale object && parse Draft boolean
		draft   : req.param "draft", false

	# Habs JSON to string
	(->
		parseHabs = JSON.parse post.hab
		habsId = []
		parseHabs.forEach (hab, index) ->
			habsId.push hab.id
			return

		post.hab = habsId.join(",")
		return
	)()

	# Tags JSON to string
	(->
		parseTags = JSON.parse post.tags
		tagsForming = []
		parseTags.forEach (tag, index) ->
			tagsForming.push tag.text
			return

		post.tags = tagsForming.join(",")
		return
	)()

	Post.create(post)

	# If create success/
	.then((post) ->

		# Publish create new record to socket.io (sails.io)
		Post.publishCreate
			verb: "postCreated"
			title: post.title
			hab: post.hab
			id: post.id

		# sails.log.info post

		# response with json data
		res.json
			success: true
			post: post
	)

	# Fail create/Handle error
	.caught((error) ->
		sails.log.error error
		# response json-data error
		res.serverError()
	)