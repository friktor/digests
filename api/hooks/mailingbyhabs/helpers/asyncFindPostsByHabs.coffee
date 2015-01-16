nodemailer = require "nodemailer"
Promise = require "bluebird"
async = require "async"
_ = require "lodash"

module.exports = (sails, habs) ->
	new Promise (resolve, reject) ->

		iteratorHab = (hab, cb) ->
			
			iteratorFindByLocale = (recipient, cbByLocale) ->
				sails.models.post.find()
				.where(
					locale: recipient.locale
					hab: hab.hab_id
				)
				.sort("createdAt desc")
				.limit(20)
				.exec (error, posts) ->
					postsForming =
						locale: recipient.locale
						posts: posts

					cbByLocale error, postsForming
					return
				return

			async.map hab.recipients, iteratorFindByLocale, (e, posts) ->
				cb e, _.merge(hab, posts: posts)
				return
			return

		async.map habs, iteratorHab, (e, result) ->
			if e then reject(e) else resolve(result)
			return
		return  