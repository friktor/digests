(->
	$modules = window.usingModule
	$modules.push "ngAnimate"

	App = angular.module "main", $modules

	App.config ["$translateProvider", ($translateProvider) ->

		# Get Translate .json
		$translateProvider.useStaticFilesLoader
			prefix: "/i18n/"
			suffix: ".json"

		# Set default language
		$translateProvider.preferredLanguage window.i18nLocale

		# Initial Hypher
		$("main.post.content p").hyphenate(window.postLocale)
		return
	]

	App.controller "CommentsListCtrl", ["$scope", "$http", "$log", "$sce", ($scope, $http, $log, $sce) ->
		
		$scope.$watch "newCommentMessage", ->
			$scope.newCommentMessage = $sce.trustAsHtml($scope.newCommentMessage)
			return

		# Get Posts
		$http.get("/utils/comment/get?target=post-"+window.postId).success((data) ->
			
			data.comments.forEach (comment, index) ->
				comment.reply.forEach (reply, index) ->
					reply.message = $sce.trustAsHtml reply.message
					return

				comment.message = $sce.trustAsHtml comment.message
				return

			$scope.countComments = data.numberOf
			$scope.comments = data.comments
			return
		)

		# Get session data
		$http.get("/utils/auth/session").success((session) ->
			$scope.auth = session.auth
			if session.auth
				$scope.username = session.username
				$scope.fullname = session.fullname
				$scope.avatars = session.avatars
			return
		)

		return
	]
)()