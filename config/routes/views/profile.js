module.exports = {
	"/profile/:username": {
	  controller: "profile", action: "index"
	},
	
	"/profile/:username/addpost": {
	  controller: "profile", action: "addpost"
	},

	"/profile/:username/settings": {
	  controller: "profile", action: "settings"
	},

	"/profile/:username/edit/:post": {
	  controller: "profile", action: "edit"
	},

	"/profile/:username/subscription": {
	  controller: "profile", action: "subscription"
	},
};