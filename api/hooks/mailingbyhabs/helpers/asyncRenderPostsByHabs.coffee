nodemailer = require "nodemailer"
Promise = require "bluebird"
async = require "async"
_ = require "lodash"
ejs = require "ejs"

module.exports = (sails, habs, template) ->
	new Promise (resolve, reject) ->

		iteratorHab = (hab, cb) ->

			iteratorObjectPostsWithLocale = (post, cbPosts) ->

				if _.size(post.posts) isnt 0
					resulter = 
						locale: post.locale
						html: ejs.render template,
							posts: post.posts
							title: sails.__
								phrase: "Interesting for your habs"
								locale: post.locale
					cbPosts null, resulter
				else cbPosts()

			async.map hab.posts, iteratorObjectPostsWithLocale, (e, rendered) ->
				delete hab.posts
				cb e, _.merge hab, rendered: _.compact(rendered)
				return

		async.map habs, iteratorHab, (error, result) ->
			if error then reject(error) else resolve(result)
			return