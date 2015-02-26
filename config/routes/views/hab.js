module.exports = {
	"get /habs": "HabController.habs",

	"get /hab/:name/:page": "HabController.byhab",
	"get /hab/:name": "HabController.byhab",

	"get /habs/:type/:page": "HabController.habsList",
	"get /habs/:type": "HabController.habsList"
};