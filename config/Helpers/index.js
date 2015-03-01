module.exports = {
	trimmedSpace: function trimmedSpace(str) {
  	return str.replace(/^\s+|\s+$/g, "")
	},

	meta: function(name, content) {
		return "<meta name=\""+name+"\" content=\""+content+"\">"
	},

	script: function(src, type) {
		return "<script src=\""+src+"\" "+(typeof type === "string" ? type : "")+"></script>"
	},

	style: function (href) {
		return "<link rel=\"stylesheet\" href=\""+href+"\">"
	},
}