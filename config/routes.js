var _ = require("lodash");

var RoutesAPI = _.merge(
  require("./routes/api/subscribe.js"),
  require("./routes/api/comment.js"),
  require("./routes/api/auth.js"),
  require("./routes/api/post.js"),
  require("./routes/api/user.js"),
  require("./routes/api/hab.js")
);

var RoutesViewsMain = _.merge(
  require("./routes/views/otherwise.js"),
  require("./routes/views/profile.js"),
  require("./routes/views/sitemap.js"),
  require("./routes/views/hab.js"),
  require("./routes/views/post.js"),
  require("./routes/views/rss.js")
);

module.exports.routes = _.merge(RoutesViewsMain, RoutesAPI);