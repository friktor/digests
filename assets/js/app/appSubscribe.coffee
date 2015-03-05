define [
	"angular",
	"js/app/app",

	"semantic-modules/dropdown",
	"semantic-modules/dimmer",
	"semantic-modules/modal",
	], (angular, App) ->

		"use strict";

		App.controller "subscribe", ["$scope", "$mdDialog", "$http", "$log", ($scope, $mdDialog, $http, $log) ->

			# Init dropdown.
			$(".ui.modal.subscribe").modal
				duration: 200
				easing: "ease"

			# Set default locale for subscribe
			$scope.locale = "ru"

			# Close modal utils
			$scope.closeModal = ->
				$(".ui.modal.subscribe").modal("hide")
				return

			# Set locale utils
			$scope.setLocale = (code) ->
				$scope.locale = code
				return

			# Function get string locale
			$scope.getLocale = (locale) ->
				switch locale
					when "en" then "english"
					when "ru" then "russian"
					when "pl" then "polish"

			# Follow actions for subscribe to source
			$scope.follow = ->

				# Params for follow
				params = 
					purpose: $scope.purpose
					locale: $scope.locale
					email: $scope.email
					type: $scope.type
					user: $scope.user

				$http.get("/csrfToken").success (token) ->
					$http.post("/utils/subscribe/create", angular.extend({}, params, token)).success (response) ->
						# Set value after response 
						if response.success 
							$scope.subscribeSuccess = true
							$scope.subscribeError = false
						else
							$scope.subscribeError = response.throw
						return
					return

			# Event function call dialog modal and event actions (subscribe, etc)
			$scope.subscribe = (opt) ->
				# Init dropdown
				$(".ui.dropdown").dropdown()

				# Set value subscribe
				$scope.purpose = opt.purpose
				$scope.email = opt.email
				$scope.type = opt.type
				$scope.user = opt.user				
				$scope.auth = opt.auth

				# Show modal window
				$(".ui.modal.subscribe").modal("show")
				return

			# Open Link function
			$scope.openLink = (link) ->
				window.history.pushState {}, $("title").text(), window.location.toString()
				window.location.replace link
			return
		]

		return