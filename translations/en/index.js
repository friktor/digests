var _ = require("lodash");

module.exports = _.merge(
	require("./errors/response.js"),
	require("./pageTitle.js"),
	require("./mail.js"),
	require("./message.js")
);