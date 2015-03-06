define [
		"angular",
		"js/app/app",
		"ng-file-upload"
	], (angular, App) ->

	"use strict";
	App.directive "uploadAvatar", ["$http", "$upload", "$timeout", "$log", "$translate", 
		($http, $upload, $timeout, $log, $translate) ->
			templateUrl: "/partials/settings/upload-avatar.html"
			restrict: "E"
			controller: ($scope) ->	
				$scope.allowUploadAvatar = true
	
				$scope.$watch "avatar", ->
					if typeof $scope.avatar isnt "undefined"

						if angular.isArray($scope.avatar) and $scope.avatar.length > 0
							if !($scope.avatar[0].type in ["image/jpeg", "image/png"])
								$scope.avatar = []
							else
								$scope.avatarUploadProgress = false
								$scope.allowUploadAvatar = false
					return
	
				$scope.uploadAvatar = -> 
					$http.get("/csrfToken").success (token) ->
						$upload.upload(
							headers: "X-CSRF-Token": token._csrf
							data: "username": window.username
							url: "/upload/uploadAvatarImage"
							fileFormDataName: "imageFile"
							file: $scope.avatar
						)
	
						.progress((evt) ->
							progressProcent = parseInt(100.0 * evt.loaded / evt.total)
							$scope.avatarUploadProgress = progressProcent
							return
						)
	
						.success (data, status) ->
							$scope.avatarMessage = data
							return
						return
					return
	
				return
	]

	return