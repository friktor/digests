(->
	# Define application
	App = angular.module "main", window.usingModule

	# Config tranlsate provider
	App.config ["$translateProvider", ($translateProvider) ->
		
		# Get Translate .json
		$translateProvider.useStaticFilesLoader
			prefix: "/i18n/"
			suffix: ".json"

		# Set default language
		$translateProvider.preferredLanguage window.i18nLocale
		return
	]

	App.controller "ProfileCtrl", ["$scope", "$http", "$log", ($scope, $http, $log) ->
		$scope.username = window.username
		$scope.redirectAllPosts = ->
			window.history.pushState {}, $("title").val(), window.location.toString()
			window.location.replace "/byauthor/#{$scope.username}"
			return
		return
	]

	App.directive "postsByUser", ["$http", "$log", ($http, $log) ->
			templateUrl: "/partials/profile/posts.html"
			controllerAs: "ByUser"
			restrict: "E"

			controller: ->
				$scope = this
				$scope.posts = []

				$http.get("/byauthor/#{window.username}?json=true").success((data) ->
					if data.posts[0]
						$scope.posts = data.posts
					return
		)
	]

)()