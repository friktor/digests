// @Routes:User
module.exports = {
	"get /utils/user/isExists": "UserController.existsUser",

	"get /utils/user/existsEmail": "UserController.existsEmail",

	"post /utils/user/register": "UserController.create",

	"get /utils/activate": "UserController.activate",

	"post /utils/user/update": "UserController.update",

	"post /utils/user/update_password": "UserController.updatePassword",

	"post /utils/user/recoveryAccount": "UserController.recoveryAccount"
}