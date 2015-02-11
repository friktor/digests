var _ = require("lodash");

module.exports = _.merge(
	require("./mail/updatePasswordNotify.js"),
	require("./mail/activateUserMail.js"),
	require("./errors/response.js"),
	require("./profile/notify.js")
);