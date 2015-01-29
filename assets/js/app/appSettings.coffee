(->
	# Define application
	App = angular.module "main", window.usingModule

	# Config tranlsate provider
	App.config ["$translateProvider", ($translateProvider) ->
		
		# Get Translate .json
		$translateProvider.useStaticFilesLoader
			prefix: "/i18n/"
			suffix: ".json"

		# Set default language
		$translateProvider.preferredLanguage window.i18nLocale
		return
	]

	# Settings Controller = main controller
	App.controller "SettingsCtrl", ["$scope", "$http", "$log", ($scope, $http, $log) ->
		$scope.tab = "personal"
	]

	# Directive personal for event update personal information.
	App.directive "personal", ["$http", "$timeout", "$log", "$mdToast", ($http, $timeout, $log, $mdToast) ->
		templateUrl: "/partials/settings/personal.html"
		controllerAs: "PersonCtrl"
		restrict: "E"

		controller: ->
			$scope = @

			$scope.update = (form) ->
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

	return
)()