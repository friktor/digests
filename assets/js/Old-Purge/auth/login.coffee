$(document).ready ->

	# Auth page
	if isLoggedIn is true
		window.history.pushState {}, i18n.login, "/login"
		window.location.replace "/"

	# variables 
	SubmitButton = $ ".ui.submit.button"
	LoginForm = $ ".ui.form.login"
	
	# options rules for validate
	options =
		username:
			identifier: "username"
			rules: [
				prompt: "\"#{i18n.username}\" - #{i18n.requiredField}"
				type: "empty" 
			]
		password: 
			identifier: "password"
			rules: [
				prompt: "\"#{i18n.password}\" - #{i18n.requiredField}"
				type: "empty"
			]
	
	# Form Validation
	LoginForm
		.form(options)
	;
	
	# Send Function
	Auth = (formData) ->
		new Promise (resolve, reject) ->
	
	  	$.post "/utils/auth/login", formData, (data, textStatus, XHR) ->
	  		resolve data.status
	  		return
	  	return
	
	# Event click button  		
	SubmitButton.click ->
		if LoginForm.form "validate form"

			SubmitButton.addClass "loading"
			
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

			Auth(
				username: nameValue "username"
				password: nameValue "password"
				_csrf: csrf
			)
	
			# event auth
			.then((resultAuth) ->
				# remove class after response
				SubmitButton.removeClass "loading"

				if resultAuth is true
					# Append message
					$("#message").empty().append "<div class=\"ui segment inverted blue\" style=\"margin-top: 10px;\">#{i18n.authSuccess}</div>"
					# visible message with transition
					# $(".ui.segment")
					# 	.transition("scale")
					# ;
					
					# timeout for redirect
					setTimeout (->
						window.history.pushState {}, i18n.login, '/login'
						window.location.replace "/"
					), 1000

				else
					# error message
					$("#message").empty().append "<div class=\"ui inverted red segment\">#{i18n.authFailed}</div>"
					# transition
					# $(".ui.segment")
					# 	.transition("scale")
					# ;
			)
	
			# event error
			.fail((error) ->
				# remove loading class if fail
				SubmitButton.removeClass "loading"

				$("#message").empty().append "<div class=\"ui inverted red segment\">#{i18n.serverError}</div>"
				# $(".ui.segment")
				# 	.transition("scale")
				# ;
			)

	return