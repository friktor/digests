module.exports = (req, res) ->

	username = req.session.user.username || undefined