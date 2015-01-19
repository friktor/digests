$(document).ready ->

	_.each ["avatar", "heading"], (name) ->

		$("##{name}").fileupload
			acceptFileTypes: /(\.|\/)(jpe?g|png)$/i
			url: "/utils/upload"
			dataType: "json"
	
			beforeSend: (xhr) ->		

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
					
				xhr.setRequestHeader 'X-CSRF-Token', csrf
				# console.log xhr
				return
	
			add: (event, data) ->
				acceptFileTypes = /(\.|\/)(jpe?g|png)$/i
				maxFileSize = 512000	
	
				errors = [`/* array with errors */`]
	
				if data.files[0]['type'].length && !acceptFileTypes.test(data.originalFiles[0]['type'])
					errors.push i18n.notAcceptedTypes
	
				if data.files[0].size > maxFileSize
					errors.push i18n.fileSizeIsBig
				
				if _.size(errors) > 0
					error = ""
					_.each errors, (e) ->
						error+= "<li>#{e}</li>"
						return
	
					setTimeout(->
						$("#message_#{name}").empty().append "<div class=\"ui inverted red segment text-center\"><ul style=\"padding-left:0; margin: 0;\">#{error}</ul></div>"
						return
					, 0)
					return
	
				else
					$(".#{name} .ui.upload.button").removeClass("disabled")
					$("#message_#{name}").empty()
	
					data.context = $(".#{name} .ui.upload.button").click ->
						data.formData = 
							username: nameValue("username")
						
						if name is "avatar" 
							data.formData.target = "avatarImg" 
						else if name is "heading"
							data.formData.target = "headingImg"
						
						data.context.addClass("loading")
						data.submit()
						return
					return
	
			done: (event, data) ->
				# if name is "avatar" 
				console.log data
				data.context.removeClass("loading")
				return

	# Personal Form validation
	$(".ui.form.personal").form
		firstname:
			identifier: "firstname"
			rules: [
				type: "empty"
			]

		lastname: 
			identifier: "lastname"
			rules: [
				type: "empty"
			]

		aboutme:
			identifier: "aboutme"
			rules: [
				type: "empty"
			]

		activitiesme: 
			identifier: "activitiesme"
			rules: [
				type: "empty"
			]

	$(".ui.personal.form .ui.submit.button").click ->
		if $(".ui.form.personal").form("validate form")
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

			Updated = 
				activitiesme: nameValue "activitiesme"
				firstname: nameValue "firstname"
				username: nameValue "username"
				lastname: nameValue "lastname"
				aboutme: nameValue "aboutme"
				socialnetwork: "[]"
				_csrf: csrf

			$.ajax
				url: "/utils/user/update"
				dataType: "json"
				data: Updated
				type: "POST"
				success: (data) ->
					if data and (data.complete is true)
						$("#message_personal").empty()
						.append "<div class=\"ui inverted green segment\"><i class=\"ifc-checkmark\"></i> #{i18n.success}</div>"
					return
				error: (xhr, status, trown) ->
					$("#message_personal").empty()
					.append "<div class=\"ui inverted red segment\"><i class=\"ifc-error\"></i> #{i18n.error_try_again}</div>"
					return
		return

	# Update password form validation

	$(".ui.form.newpass").form
		newpass:
			identifier: "newpass"
			rules: [
				{type: "length[7]"},
				{type: "empty"}
			]

		confirm: 
			identifier: "confirm"
			rules: [
				{type: "match[newpass]"},
				{type: "empty"}
			]

	$(".ui.form.newpass .ui.submit.button").click ->
		if $(".ui.form.newpass").form("validate form")

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

			NewPass = 
				username: nameValue "username"
				newpass: nameValue "newpass"
				_csrf: csrf

			console.log NewPass

			$.ajax
				url:  "/utils/user/update_password"
				dataType: "json"
				data: NewPass
				type: "POST"
				success: (data) ->
					if data and (data.complete is true)
						$("#message_newpass").empty()
						.append "<div class=\"ui inverted green segment\"><i class=\"ifc-checkmark\"></i> #{data.message}</div>"
						return

				error: (xhr, status, trown) ->
					console.log status
					console.log trown

					$("#message_newpass").empty()
					.append "<div class=\"ui inverted red segment\"><i class=\"ifc-error\"></i> #{i18n.error_try_again}</div>"					
					return
			return

	return
