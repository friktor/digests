$(document).ready ->
	
	$(".unsubscribe.button").each (numberOf, elem) ->	
		$(this).click ->
			subscribeId = $(this).data("subscribe")
			subscribeItem = $(".item[data-subscribeid=\"#{subscribeId}\"]")

			# csrf
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

			$.ajax
				url: "/utils/subscribe/destroy"
				dataType: "json"
				type: "post"
				data: 
					username: nameValue "username"
					id: subscribeId
					_csrf: csrf

				success: (data) ->
					if !data.success
						$("#message").empty().append "<div class=\"ui segment invered red\">#{i18n.serverError}</div>"
					else
						subscribeItem.transition
							animation: "drop"
							duration: "250ms"
							onHide: ->
								subscribeItem.remove()
								return
					return

				error: (xhr, error, thrown) ->
					$("#message").empty().append "<div class=\"ui segment invered red\">#{i18n.serverError}</div>"
					return
			
	return