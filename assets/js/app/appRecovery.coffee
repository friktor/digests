define [
	"angular",
	"js/app/app"
	], (angular, App) ->
		"use strict";

		App.directive "recoveryForm", ["$http", "$log", ($http, $log) ->
			templateUrl: "/partials/recovery.html"
			restrict: "E"
			controller: ["$scope", ($scope) ->
				$scope.recovery = ->
					$http.get("/csrfToken").success (token) ->
						form = angular.extend({}, token, email: $scope.email)
						$http.post("/utils/user/recoveryAccount", form).success (response) ->
							switch response.success
								when true then $scope.success = true
								when false
									$scope.throw = response.throw
									$scope.success = false
							return
						return
					return
				return
			]
							
		]

		return