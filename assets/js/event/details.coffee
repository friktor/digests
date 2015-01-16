#  Comment block event(s)

$(document).ready ->
	$('.content p').hyphenate(locale);

	$(".comment").each (i, elem) ->
		$(this).click ->
			
			$(".comments .comment")
				.removeClass("enable big")
			;
	
			$(this)
				.addClass("enable big")
			;
	
			return
		return

	$(".ui.form.newcomment").form
		comment: 
			identifier: "comment"
			rules: [
				type: "empty"
			]

	$(".ui.form.newcomment .ui.submit").click ->
		if $(".ui.form.newcomment").form("validate form")
			csrf = ((url) ->
				result = null

				$.ajax
					async: false
					url: url
					dataType: "json"
					success: (r) ->
						result = r._csrf

				return result
			)("/csrfToken")

			Comment = 
				username: nameValue "username"
				message: nameValue "comment"
				author: nameValue "author"
				post: postId
				_csrf: csrf

			$.ajax
				url: "/utils/comment/create"
				dataType: "json"
				type: "post"
				data: Comment

				success: (data) ->

					$("#message_comment").empty()
						.append "<div class=\"ui inverted green segment\"> <i class=\"ifc-checkmark\"></i> #{i18n.updatePage}</div>"

					setTimeout(window.location.reload(), 1500)
					return

				error: ->
					$("#message_comment").empty()
						.append "<div class=\"ui inverted red segment\"><i class=\"ifc-error\"></i> #{i18n.error_try_again}</div>"
					return
		

	# Ending return
	return
