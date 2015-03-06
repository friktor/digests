define [
		"angular"
		"js/app/app"
	], (angular, App) ->
		"use strict";

		App.directive "changePassword", ["$http", "$log", ($http, $log) ->
			templateUrl: "/partials/settings/update-password.html"
			restrict: "E"
			controller: ["$scope", ($scope) ->
				$scope.update = ->
					$scope.process = true

					form = 
						username: window.username
						password: $scope.newpass

					$http.get("/csrfToken").success (token) ->
						$http.post("/utils/user/update_password", angular.extend({}, token, form)).success (response) ->							
							if response.success 
								$scope.success = true
								$scope.process = false
							return
						return
					return
			]
		]