module.exports = (req, res, next) ->
	#sails.log("author:: #{req.param "author"}\n session:id - #{req.session.user.id}")
	if (req.param("author") is req.session.user.id) or req.session.user.admin is true
		next()
	else 
		sails.log "Forbid comment"
		res.forbidden()
