module.exports = {
	// Posts
	"get /sitemaps/posts.xml": {
	  controller: "sitemap", action: "posts"
	},

	// Profiles
	"get /sitemaps/profiles.xml": {
	  controller: "sitemap", action: "profiles"
	},

	// Otherwise pages

	"get /sitemaps/otherwise.xml": {
	  controller: "sitemap", action: "otherwise"
	},
};