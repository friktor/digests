define [
	"angular",
	"js/app/app",
	"stagging/lodash.min"
	], (angular, App, lodash) ->

		App.controller "subscriptions", ["$scope", "$http", "$log", ($scope, $http, $log) ->
			
			$scope.unsubscribe = (id) ->
				$http.get("/csrfToken").success (token) ->
					$http.post("/utils/subscribe/destroy", angular.extend({}, token, id: id)).success (response) ->
						if response.success
							index = lodash.findIndex($scope.subscriptions, "id": id)
							$scope.subscriptions.splice index, 1
							return
						return
					return
				return

			if window.validUrl is window.location.toString()
				$http.get("/profile/#{window.username}/subscriptions?ajax=true").success (response) ->
					$scope.subscriptions = response.subscriptions
					$scope.user = response.user
					return			
			return
		]