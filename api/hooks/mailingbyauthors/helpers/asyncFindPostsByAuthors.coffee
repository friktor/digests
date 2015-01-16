Promise = require "bluebird"
async = require "async"
_ = require "lodash"

module.exports = (sails, authors) ->
	new Promise (resolve, reject) ->
		
		iterator = (author, cb) ->
			sails.models.post.find()

			.where(author: author.author_id)
			.sort("createdAt desc")
			.limit(20)

			.exec (error, posts) ->
				cb error, _.merge(author, posts: posts)
				return

		async.map authors, iterator, (error, result) ->
			if error then reject(erorr) else resolve(result)
			return
		return