#@action: create
#@description: create new post in DB
#@params:	{content: contentMarkdown}, 
#					{locale: language_posts}, 
#					{headingImage: link},
#					{author: author_id}, 
#					{title: title}, 
#					{hab: hab_id array string, "id_1, id_2, etc.."}

#@dependencies: defaults {{none}}

module.exports = (req, res) ->
	post = 
		# Main param
		headerImg: req.param "header_img" # header image 
		author  : req.param "author"      # author (associations_id)
		content : req.param "content"     # content main
		locale  : req.param "locale"      # language post
		title   : req.param "title"       # title post
		hab     : req.param "hab"         # hab array (via ,)
		tags    : req.param "tags"        # tags
		
		# Locale object && parse Draft boolean
		draft   : req.param "draft"

	Post.create(post)

	# If create success/
	.then((post) ->

		# Publish create new record to socket.io (sails.io)
		Post.publishCreate
			verb: "postCreated"
			title: post.title
			hab: post.hab
			id: post.id

		# response with json data
		res.json post
	)

	# Fail create/Handle error
	.caught((error) ->
		# response json-data error
		res.json error.toJSON()
	)