$(document).ready ->
	subscribeBtn = $ "#modal_subscribe"
	Modal = $ ".ui.modal.subscribe"
	
	# Init modals
	Modal.modal
		transition: "fade up"
		closable : false
		
		selector :
			close : ".close, .ui.button.negative"
	
	# Click eventer
	subscribeBtn.click ->
		# Show modal
		Modal.modal "show"
		return

	Modal.find(".actions .ui.button.positive").click ->
		# _csrf
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

		# Main params
		params = 
			from: $(".ui.modal.subscribe input[name=\"from\"]").val()
			by: $(".ui.modal.subscribe input[name=\"by\"]").val()
			email: $(".ui.modal.subscribe input[name=\"email\"]").val()
			_csrf: csrf

		# If loggedin
		if isLoggedIn
			params.user = $(".ui.modal.subscribe input[name=\"user\"]").val()

		$.ajax
			url: "/utils/subscribe/create"
			dataType: "json"
			data: params
			type: "post"

			success: (data) ->
				console.log data

				if data.success is true
					Modal.find(".content .description")
						.append("<div style=\"visibility: hidden;\" class=\"ui inverted green segment\"><i class=\"ifc-checkmark\"></i> #{data.message}</div>")
					
					Modal.find(".ui.inverted.green.segment").transition("fade up")
					$(".ui.modal.subscribe .ui.button.positive").remove()
					return
				else
					Modal.find(".content .description")
						.append("<div style=\"visibility: hidden;\" class=\"ui inverted red segment\"><i class=\"ifc-error\"></i> #{data.message}</div>")

					Modal.find(".ui.inverted.red.segment").transition("fade up")
					return

			error: (xhr, error, thrown) ->
				Modal.find(".content .description")
					.append("<div style=\"visibility: hidden;\" class=\"ui inverted red segment\"><i class=\"ifc-error\"></i> #{i18n.error}</div>")

				Modal.find(".ui.inverted.red.segment").transition("fade up")
				return

	return