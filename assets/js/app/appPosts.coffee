define [
		"jquery",
		"angular",
		"masonry",
		"js/app/app"
	], ($, angular, Masonry, App) ->

	"use strict";
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
		
			new Masonry document.querySelector(".posts.lists .row"), 
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
				new Masonry(document.querySelector(".posts.lists .row")).reloadItems()
				return
			, (error) ->
				new Masonry(document.querySelector(".posts.lists .row")).reloadItems()
				return
			)
			return
		]

	return
