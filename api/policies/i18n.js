module.exports = function (req, res, next) {
	if (req.param("_Locale")) {req.setLocale(req.param("_Locale"));} 
	next();
};