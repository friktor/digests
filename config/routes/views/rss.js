module.exports = {
	// By Hab
	"get /rss/hab/:name.xml": {
	  controller: "rss", action: "hab"
	},

	"get /rss/hab/:name/:locale.xml": {
	  controller: "rss", action: "hab"
	},

	// By author
	"get /rss/author/:username.xml": {
	  controller: "rss", action: "byauthor"
	},

	// Main
	"get /rss/latest.xml": {
	  controller: "rss", action: "latest"
	},

	"get /rss/latest/:locale.xml": {
	  controller: "rss", action: "latest"
	},
};