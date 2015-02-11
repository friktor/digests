module.exports = {
	"get /latest/:page": {
	  controller: "post", action: "latest"
	},

	"get /popular/:page": {
	  controller: "post", action: "popular"
	},
	
	"get /popular": {
	  controller: "post", action: "popular"
	},

	"get /latest": {
	  controller: "post", action: "latest"
	},

	"get /details/:id": {
	  controller: "post", action: "details"
	},

	"get /byauthor/:username/:page": {
	  controller: "post", action: "byauthor"
	},

	"get /byauthor/:username": {
	  controller: "post", action: "byauthor"
	}
};