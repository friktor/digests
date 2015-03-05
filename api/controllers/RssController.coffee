require "coffee-script/register"

module.exports = 

	byauthor: require "./rss/byauthor.coffee"

	latest: require "./rss/latest.coffee"

	hab: require "./rss/hab.coffee"

	_config: 
		shortcuts: false 
		actions: false 
		rest: false