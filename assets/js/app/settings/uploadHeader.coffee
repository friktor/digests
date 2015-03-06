define [
		"angular",
		"js/app/app"
	], (angular, App) ->

	"use strict";
	App.directive "uploadHeader", ["$http", "$upload", "$timeout", "$log", 
		($http, $upload, $timeout, $log) ->
			templateUrl: "/partials/settings/upload-header.html"
			restrict: "E"
			controller: ["$scope", ($scope) ->
				$scope.allowUploadHeader = true
				$scope.$watch "header", ->
					if typeof $scope.header isnt "undefined"
						if angular.isArray($scope.header) and $scope.header.length > 0
							if !($scope.header[0].type in ["image/jpeg", "image/png"])
								$scope.header = []
							else
								$scope.headerUploadProgress = false
								$scope.allowUploadHeader = false
					return

				$scope.uploadHeader = ->
					$http.get("/csrfToken").success (token) ->
						$upload.upload(
							url: "/upload/uploadProfileHeadingImage"
							headers: "X-CSRF-Token": token._csrf
							data: "username": window.username
							fileFormDataName: "imageFile"
							file: $scope.header
						)

						.progress((evt) ->
							progressProcent = parseInt(100.0 * evt.loaded / evt.total)
							$scope.headerUploadProgress = progressProcent
							return
						)

						.success((data, status) ->
							$scope.headerMessage = data
							return
						)

						.error((error, thrown) ->
							$log.error thrown
							$log.error error
							return
						)

						return
					return
					
				return
			]
	]

	return
