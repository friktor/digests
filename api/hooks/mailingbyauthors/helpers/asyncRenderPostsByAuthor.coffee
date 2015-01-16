Promise = require "bluebird"
async = require "async"
_ = require "lodash"
ejs = require "ejs"

module.exports = (sails, authors, template) ->
	new Promise (resolve, reject) ->

		iterator = (author, cb) ->
			sails.models.user.findOne().where(id: author.author_id).then (user) ->
				data = 
					title: "Respond posts by #{user.firstname} #{user.lastname}"
					posts: author.posts
					
				html = ejs.render(template, data)
				delete author.posts

				cb null, _.merge author,
					html : ejs.render(template, data)
					title: data.title
				return
			return

		async.map authors, iterator, (error, result) ->
			if error then reject(error) else resolve(result)
			return
		return