define [
		"jquery",
		"angular",
		"js/app/app",

		"js/directives/compare",

		"js/app/appRecovery",
		"js/app/appRegister",
		"js/app/appLogin",

		"js/app/settings/updatePersonal",
		"js/app/settings/uploadAvatar",
		"js/app/settings/uploadHeader",
		"js/app/settings/updatePassword",
		
		"js/app/appProfile",
		"js/app/appDetails",
		"js/app/appPosts",
		"js/app/editPostApp",
		"js/app/addPostApp",
		"js/app/appSubscribe",
		"js/app/appSubscriptions",
		"js/app/appHome",

		"js/actions/habsMasonry",

		"semantic-modules/dropdown",
		"semantic-modules/sidebar"

		# TODO: Удалить, и подтягивать через bower
		"stagging/jquery.hypher"
	], ($, angular) ->

	$ () -> angular.bootstrap document, ["app"], {strictDi: true}

	$ () ->
		$(".ui.sidebar").sidebar
			transition: "overlay"
			dimPage: false
			duration: 250

		$(".item.sidebar.show_").click ->
			$("#mainLeftSidebar").sidebar("show")
			return

		$(".ui.secondary.menu.header .ui.login.button").click ->
			$("#topLoginSidebar").sidebar("show")
			return

		$(".ui.dropdown").dropdown()

		$("textarea").keydown (e) ->
			if e.keyCode is 9
				start = @selectionStart
				end = @selectionEnd
				$this = $(this)
				$value = $this.val()

				$this.val($value.substring(0, start)+"\t"+$value.substring(end))
				@selectionStart = @selectionEnd = start+1
				e.preventDefault()
			return

		$("main.post.content p").hyphenate(window.postLocale)

		return
	return
