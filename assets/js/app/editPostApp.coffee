define [
		"angular",
		"js/app/app",

		"remarkable",
		"highlightjs",
	], (angular, App, Remarkable, hljs) ->

	"use strict";
	App.controller "EditPost", ["$scope", "$http", "$upload", "$log", "$timeout",
		($scope, $http, $upload, $log, $timeout) ->

			$http.get("/profile/#{window.username}/edit/#{window.editPostNumericId}?json=true").success (data) ->
				$scope.postContent = data.post.content
				$scope.markLang = data.post.markLang
				$scope.postTitle = data.post.title
				$scope.habs = data.post.habs
				$scope.tags = data.post.tags
				return

			$scope.markdown = new Remarkable "full",
				langPrefix: "language-"
				typographer: true
				xhtmlOut: false
				linkify: true
				breaks: true
				html: true
				quotes: '“”‘’'
				highlight: (str, lang) ->
					if lang and hljs.getLanguage(lang)
						try
							# $log.info lang
							return hljs.highlight(lang, str).value
						catch e
					
					try
						$log.info str
						return hljs.highlightAuto(str).value
					catch e
					
					return ""

			$scope.$on "$viewContentLoaded", ->
				$(".ui.dropdown").dropdown()
				# $log.info "Content:loaded"
				return

			$scope.$watch "postContent", ->
				$scope.$previewMarkdown = $scope.markdown.render $scope.postContent
				return

			$scope.$watch "postHeaderImage", ->
				if typeof $scope.postHeaderImage isnt "undefined"

					if angular.isArray($scope.postHeaderImage) and $scope.postHeaderImage.length > 0
						if !($scope.postHeaderImage[0].type in ["image/jpeg", "image/png"])
							$scope.postHeaderImage = []
						else
							fileReader = new FileReader()
							fileReader.readAsDataURL $scope.postHeaderImage[0]
							fileReader.onload = (evt) ->
								$timeout ->
									$scope.thumbnail = evt.target.result
									return
								return
						return 

			$scope.headerImgType = "link"
			$scope.disabledUploadButton = true
			$scope.markLang = "markdown"

			$scope.loadHabs = ($query) ->
				$http.get("/utils/hab/publicList")

			$scope.isShowSetHeader = (type) ->
				$scope.headerImgType is type

			$scope.setMarkupLang = (lang) ->
				$scope.markLang is lang

			$scope.submit = ->

				# $log.info "Start create new post::"

				# valid:hab
				$validHabs = ->
					typeof $scope.habs isnt "undefined" and $scope.habs.length > 0
				# valid:tags
				$validTags = ->
					typeof $scope.tags isnt "undefined" and $scope.tags.length > 0
				# valid:content
				$validContent = ->
					typeof $scope.postContent is "string" and $scope.postContent.length > 0

				$setLocale = ->
					$locale = $("input[name=\"locale\"]").val()
					if $locale.length > 0 then $locale else "ru"

				if $validContent() and $validTags() and $validHabs()
					
					formPost = 
						content: $scope.postContent
						markLang: $scope.markLang
						title: $scope.postTitle
						author: window.userId
						tags: JSON.stringify($scope.tags)
						habs: JSON.stringify($scope.habs)
						locale: $setLocale()

					$log.info formPost

					$uploadHeaderImage = (postId) ->
						# $log.info "StartUploading::"

						$sendHeaderUrl = () ->
							# $log.info "StartUploading:: From Link"

							if $scope.headerImageLink isnt "undefined" and $scope.headerImageLink.length > 0
								$http.get("/csrfToken").success (token) ->
									$scope.startUploadheaderImage = true
	
									paramsImage = 
										imageLink: $scope.headerImageLink
										uploadType: "link"
										postId: postId
	
									$http.post("/upload/uploadPostHeaderImages", angular.extend({}, paramsImage, token))
		
									.success((data, status) ->
										$scope.UploadResult = data.success or status
										# $log.info data
										return
									)
	
									.error (error) ->
										$scope.UploadResult = false
										$scope.UploadError = error
										# $log.error error
										return
									return
							return

						$uploadHeader = ->
							# $log.info "StartUploading::"

							if $scope.postHeaderImage and $scope.postHeaderImage.length > 0
								$http.get("/csrfToken").success (token) ->
									$scope.startUploadheaderImage = true
									
									$upload.upload(
										headers: "X-CSRF-Token": token._csrf
										url: "/upload/uploadPostHeaderImages"
										file: $scope.postHeaderImage
										fileFormDataName: "image"
										data:
											uploadType: "upload" 
											postId: postId
									)
									
									.progress((evt) ->
										progressProcent = parseInt(100.0 * evt.loaded / evt.total)
										$scope.headerUploadProgress = progressProcent
										# $log.info "Progress: "+progressProcent+"%;"
										return
									)
		
									.success((data, status) ->
										$scope.UploadResult = data.success or status
										return
									)
	
									.error((error) ->
										$scope.UploadError = error
										$scope.UploadResult = false
										# $log.error error
										return
									)
							return


						switch $scope.headerImgType
							when "upload" then $uploadHeader()
							when "link" then $sendHeaderUrl()
						return

					$log.info "Send post form with data"

					$http.get("/csrfToken").success((token) ->
						$http.post("/utils/post/update", angular.extend({}, formPost, token, {id: window.editPostId}))

						.success((data, status) ->
							# $log.info "Reply from server:: data Created\n"

							$scope.successCreatePost = data.success || false
							$scope.linkToPost = "/details/#{data.post.numericId}"
							if data.success then $uploadHeaderImage(window.editPostId)
						)

						.error((error) ->
							# $log.error "Error in request create post: #{error}"
							return
						)
					)
					.error((error) ->
						# $log.error "Error in request _CSRF token: #{error}"
						return
					)
				return

	]

	return
