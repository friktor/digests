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

	return