define [
		"angular",
		"js/app/app"
	], (angular, App) ->

	"use strict";
	App.directive "registerForm", ["$http", "$log", "vcRecaptchaService", ($http, $log, $reCaptcha) ->
		templateUrl: "/partials/register.html"
		restrict: "E"
		controller: ($scope) ->
			$scope.$watch "username", ->
				$http.get("/utils/user/isExists?username=#{$scope.username}").success (response) ->
					$scope.isExistsUsername = response.exists
					$log.info $scope.isExistsUsername
					return
				return
	
			$scope.$watch "email", ->
				$http.get("/utils/user/existsEmail?email=#{$scope.email}").success (response) ->
					$scope.isExistsEmail = response.exists
					$log.info $scope.isExistsEmail
					return
				return
	
			$scope.submit = ->
				$scope.allowShowErrors = true
				
				if $scope.registerForm.$valid and $scope.agreeTerms
					$formData = 
						username: $scope.username
						password: $scope.password
						email: $scope.email
			
						firstname: $scope.firstname
						lastname: $scope.lastname
						captcha: $reCaptcha.getResponse()
	
					$scope.disableInputs = true
			
					$http.get("/csrfToken").success((token) ->
						$http.post("/utils/user/register", angular.extend({}, token, $formData)).success((response) ->	
							$log.info response
							
							if response.success
								$scope.successRegister = true
								return
							else
								$scope.disableInputs = false
						)	
					)
				return	
			return
	]

	# App.directive('ngModelOnblur', function() {
	#     return {
	#         priority: 1,
	#         restrict: 'A',
	#         require: 'ngModel',
	#         link: function(scope, elm, attr, ngModelCtrl) {
	#             if (attr.type === 'radio' || attr.type === 'checkbox') return;
	            
	#             elm.off('input keydown change');
	#             elm.on('blur', function() {
	#                 scope.$apply(function() {
	#                     ngModelCtrl.$setViewValue(elm.val());
	#                 });         
	#             });
	#         }
	#     };
	# })

	return
