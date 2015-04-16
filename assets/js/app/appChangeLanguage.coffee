define [
	"angular",
	"js/app/app"
	], (angular, App) ->

		"use strict";

		App.controller "changeLanguage", ["$scope", "$translate", "$log", "$http", ($scope, $translate, $log, $http) ->
			$scope.selectLanguage = (key) ->
				$http.get("/setlocale/#{key}").success((data) ->)
				$translate.use key
			return
		]

		return