// @Routes:Authentitication

module.exports = {
	"post /utils/auth/login": "AuthController.auth",
	"get /utils/auth/isloggedin": "AuthController.isLoggedIn"
}