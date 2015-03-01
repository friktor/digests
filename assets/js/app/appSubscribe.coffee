define [
	"angular",
	"js/app/app"
	], (angular, App) ->

		"use strict";

		App.controller "subscribe", ["$scope", "$mdDialog", "$http", "$log", ($scope, $mdDialog, $http, $log) ->

			# Event function call dialog modal and event actions (subscribe, etc)
			$scope.subscribe = (opt) ->
				
				# Controller for modal
				controllerDialog = ($scope) ->
					$scope.auth = opt.auth
					$scope.locale = "ru"

					$scope.getLocale = (locale) ->
						switch locale
							when "en" then "english"
							when "ru" then "russian"
							when "pl" then "polish"

					$scope.follow = ->

						params = 
							locale: $scope.locale
							purpose: opt.purpose
							email: opt.email
							type: opt.type
							user: opt.user

						$http.get("/csrfToken").success((token) ->
							$http.post("/utils/subscribe/create", angular.extend({}, params, token)).success((response) ->

								if response.success 
									$scope.subscribeSuccess = true
									$scope.subscribeError = false
								else
									$scope.subscribeError = response.throw
							)
						)
					return

				# Show Modal
				$mdDialog.show
					templateUrl: "/partials/elements/subscribe.modal.html"
					controller: controllerDialog
					parent: opt.parentElement

				return

			$scope.openLink = (link) ->
				window.history.pushState {}, $("title").text(), window.location.toString()
				window.location.replace link
			return
		]

		return