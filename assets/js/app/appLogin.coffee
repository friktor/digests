(->
	App = angular.module "login", []

	App.directive "loginForm", ["$http", "$timeout", "$log", ($http, $timeout, $log) ->

		templateUrl: "/partials/login.html"
		restrict: "E"
		
		controller: ->
			$self = @
			
			# formData
			$self.formData =
				username: ""
				password: ""

			# Set scope variables (i18n)
			$self.__ =
				subHeader: "Auth on Digests.me"
				username: "username"
				password: "password"
				login: "Login"

			@Auth = (form) ->
				$http.get("/csrfToken").success (token) ->

					formData = angular.extend({}, form, token)
					# $log.info formData

					$http.post("/utils/auth/login", formData).success (response) ->
						# $log.info response

						if response.success
							
							# Redirect function after login
							redirect = ->
								window.history.pushState {}, $("title").val(), window.location.toString()
								window.location.replace "/"
								return

							# Show success message
							$self.success = response.message
							
							# Hidden error message
							$self.error = undefined
							
							# timeout redirect() after 1200ms
							$timeout redirect, 1200
						else
							$self.error = response.message
						return
					return
				return

			return

		controllerAs: "LoginCtrl"
	]

)()