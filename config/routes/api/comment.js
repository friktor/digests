module.exports = {
	"post /utils/comment/create": "CommentController.create",
	"get /utils/comment/get": {
		controller: "comment", action: "get"
	},
}