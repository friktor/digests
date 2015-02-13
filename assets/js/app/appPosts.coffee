(->
	App = angular.module "main", window.usingModule

	App.config ["$translateProvider", ($translateProvider) ->
		
		# Get Translate .json
		$translateProvider.useStaticFilesLoader
			prefix: "/i18n/"
			suffix: ".json"

		# Set default language
		$translateProvider.preferredLanguage window.i18nLocale

		# Init dropdown
		$(".ui.dropdown").dropdown()
		return
	]

	App.controller "PostsCtrl", ["$scope", "$http", "$log", "$mdDialog", 
		
		($scope, $http, $log, $mdDialog) ->
		
			$scope.locationPage = window.postsPage
			$scope.page = window.thisPage
			$scope.posts = []
	
			$scope.loadPosts = ->
				$getlocale = "?locale=#{window.locale}"
				$getDatUrl = $scope.locationPage+"/"+($scope.page+1)+"#{$getlocale}&ajax=true"

				$http.get($getDatUrl)
	
				.success((response) ->					
					window.history.pushState {}, $("title").text(), $scope.locationPage+"/"+($scope.page+1)+$getlocale
					$scope.posts = $scope.posts.concat(response.posts)
					
					$("title").text(response.title)
					$scope.page += 1
					return
				)
	
				.error((data, status, headers) ->
					$scope.notify = if parseInt(status) is 404 then "404. More posts not found." else "#{status} #{data}"
					return
				)
	
				return
		
			$(".posts.lists .row").masonry
				itemSelector: ".posts.lists .row .masonry-brick"
				columnWidth: ".posts.lists .row .masonry-brick"
	
			return
	]

	App.directive "postImg", ["lazyload", ($lazyload) ->
		link: ($scope, $element, $attributes, controller) ->
			sourceUrl = $element.attr("src")
			loadImage = $lazyload sourceUrl, $element, $attributes
			
			loadImage

			.then((img) ->
				$(".posts.lists .row").masonry("reloadItems").masonry()
				return
			, (error) ->
				$(".posts.lists .row").masonry("reloadItems").masonry()
				return
			)
			return
		]

	return
)()