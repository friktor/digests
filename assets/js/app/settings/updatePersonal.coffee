define [
		"angular",
		"js/app/app"
	], (angular, App) ->

	"use strict";	

	App.directive "personal", ["$http", "$timeout", "$log", "$mdToast", ($http, $timeout, $log, $mdToast) ->
		templateUrl: "/partials/settings/personal.html"
		restrict: "E"
		controller: ["$scope", ($scope) ->

			$scope.updatePersonal = (form) ->
				$scope.request = true
		
				$http.get("/csrfToken").success((token) ->
					form = angular.extend {}, form, token
					$http.post("/utils/user/update", form)
		
					.success((data) ->
						$scope.request = false
		
						if data.success
							$mdToast.show $mdToast.simple().content(data.message).position("top right").hideDelay(1000)
							$scope.Form = data.user
						return
					)
					
					.error((data, status) ->
						$scope.request = false
		
						$mdToast.show($mdToast.simple()
							.content(status+" "+data)
							.position("top right")
							.hideDelay(1000)
						)
						return
					)
				)
				return
		
			$http.get("/profile/#{window.username}/settings?user-data=true").success (user) ->
				delete user.headingImg
				delete user.avatarImg
				$scope.Form = user
				return
		
			return	
		]
	]

	return
