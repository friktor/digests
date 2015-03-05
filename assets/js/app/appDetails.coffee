define [
		"angular",
		"js/app/app",
		"stagging/lodash.min",
	], (angular, App, lodash) ->

	"use strict";
	App.controller "CommentsListCtrl", ["$scope", "$http", "$log", "$sce", ($scope, $http, $log, $sce) ->

		$scope.reply = false

		# Set normal mode (isnt reply)
		$scope.setNormal = -> 
			$scope.replyTarget = undefined
			$scope.reply = false
			return

		# Set reply params
		$scope.setReply = (target) ->
			$scope.replyTarget = target
			$scope.reply = true
			return

		# Utils for valid owned comment
		$scope.isOwner = (username) ->
			$scope.username is username

		$scope.addComment = (validForm, message)->
			$scope.clickedSubmit = true
			
			if validForm
				params = 
					replyTarget: $scope.replyTarget
					target: "post-"+window.postId
					author: $scope.username
					reply: $scope.reply
					message: message

				$http.get("/csrfToken").success((token) ->
					$http.post("/utils/comment/create", angular.extend({}, token, params)).success((response) ->
						if response.success
							# Clean form if success
							$scope.newCommentMessage = null
							$scope.clickedSubmit = false

							# Push responsed comment to list
							switch response.comment.reply
								when true
									indexGlobal = lodash.findIndex $scope.comments, "id": response.comment.replyTarget
									$scope.comments[indexGlobal].reply.push response.comment
								when false
									$scope.comments.push response.comment							
						return
					)
				)
			return

		# Utils for remove existing comment
		$scope.removeComment = (params) ->

			# Params for request
			$params = 
				comment: params.comment
				author: params.author
			
			# Get csrf token
			$http.get("/csrfToken").success (token) ->
				# Send params for remove comment with token
				$http.post("/utils/comment/remove", angular.extend({}, token, $params)).success (response) ->
					if response.success
						# Actions swith for remove comment or reply from comments array
						switch params.reply
							when true # find index parent comment, and splice reply
								indexParent = $scope.comments.indexOf(params.parent)
								$scope.comments[indexParent].reply.splice(params.index, 1)
							when false # splice global comment
								$scope.comments.splice(params.index, 1)
					return		
				return
			return

		
		$scope.$watch "newCommentMessage", ->
			$scope.newCommentMessage = $sce.trustAsHtml($scope.newCommentMessage)
			return

		if window.validUrl is window.location.toString()
			
			# Get session data
			$http.get("/utils/auth/session").success (session) ->
				# Set auth bool value
				$scope.auth = session.auth
	
				# Set variables for session user data
				if session.auth
					$scope.username = session.username
					$scope.fullname = session.fullname
					$scope.avatars = session.avatars
				return
			
			# Get Posts
			$http.get("/utils/comment/get?target=post-"+window.postId).success (data) ->
				
				# Protected html comments and reply to comment
				data.comments.forEach (comment, index) ->
					comment.reply.forEach (reply, index) ->
						reply.message = $sce.trustAsHtml reply.message
						return
					# Protect
					comment.message = $sce.trustAsHtml comment.message
					return
	
				$scope.comments = data.comments
				return

		return
	]
	
	return