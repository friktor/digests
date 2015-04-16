module.exports = {
	"/": "SiteController.homepage",

	"/about": "SiteController.about",

	"/login": "AuthController.login",

	"/register": "AuthController.register",

	"/logout": "AuthController.logout",

	"get /setlocale/:locale": {
	  controller: "auth", action: "settingLocale"
	},

	"/recovery": "SiteController.recovery",
};