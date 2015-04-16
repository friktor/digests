define [
	"angular",
	"js/app/app"
], (angular, App) ->

	"use strict";

	App.controller "homepage", ["$scope", ($scope) ->
		$scope.defaultForm = "login"

		$scope.changeForm = (form) ->
			$scope.defaultForm = form
			return

		$scope.isShow = (form) ->
			$scope.defaultForm is form

		return
	]

