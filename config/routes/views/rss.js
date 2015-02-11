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
	"get /rss/newest.xml": {
	  controller: "rss", action: "newest"
	},

	"get /rss/newest.:locale.xml": {
	  controller: "rss", action: "newest"
	},
};