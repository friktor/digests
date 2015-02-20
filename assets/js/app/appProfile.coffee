define [
		"angular",
		"js/app/app"
	], (angular, App) ->

	"use strict";
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

			$http.get("/byauthor/#{window.username}?json=true").success (data) ->
				if data.posts[0]
					$scope.posts = data.posts
				return
			
	]

	return