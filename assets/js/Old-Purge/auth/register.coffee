$(document).ready ->
	# if logged in - redirect
	if isLoggedIn is true
		window.history.pushState {}, i18n.login, "/login"
		window.location.replace "/"
	
	# variables
	ButtonRegister = $ ".ui.button.submit"
	FormRegister   = $ ".ui.form.register"

	options =
		username:
			identifier: "username"
			rules: [
				prompt: "\"#{i18n.username}\" - #{i18n.requiredField}"
				type: "empty" 
			]

		password: 
			identifier: "password"
			rules: [{
				prompt: "\"#{i18n.password}\" - #{i18n.requiredField}"
				type: "empty"
			}, {
				prompt : "#{i18n.minLengPass}"
				type   : 'length[6]'
			}]

		confirmation:
			identifier: "confirmation"
			rules: [{
				prompt: "\"#{i18n.passNotMatchConfirm}\""
				type: "match[password]",
			}, {
				prompt: "\"#{i18n.confirmation}\" - #{i18n.requiredField}"
				type: "empty",
			}]

		email: 
			identifier: "email",
			rules: [{
				prompt: "\"Email\" - #{i18n.thisIsEmail}"
				type: "email"
			}, {
				type: "empty",
				prompt: "\"Email\" - #{i18n.requiredField}"
			}]

		terms: 
			identifier: "terms",
			rules: [type: "checked"]

		firstname: 
			identifier: "firstname"
			rules: [type: "empty"]

		lastname: 
			identifier: "lastname"
			rules: [type: "empty"]

	
	# Init checkbox
	$(".ui.checkbox")
		.checkbox()
	;

	# form validate
	FormRegister
		.form(options)
	;


	# send data form to server
	Register = (dataForm) ->
		new Promise (resolve, reject) ->
			$.post "/utils/user/register", dataForm, (data) ->
				resolve data.complete
				return
			return

	# Button event

	ButtonRegister.click ->
		if FormRegister.form "validate form"
			# Add loading class
			ButtonRegister.addClass "loading"

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

			Register(
				username: nameValue "username"
				password: nameValue "password"
				firstname: nameValue "firstname"
				lastname: nameValue "lastname"
				email: nameValue "email"
				_csrf: csrf
			)

			.then((status) ->
				# remove loading class
				ButtonRegister.removeClass "loading"

				if status is true
					# Append message
					$("#message").empty().append("<div class=\"ui segment inverted blue\" style=\"margin-top: 10px;\">#{i18n.hasBeenRegister}</div>")
					
					# timeout for redirect
					setTimeout (->
						window.history.pushState {}, i18n.register, '/register'
						window.location.replace "/"
					), 1000
				else
					$("#message").empty().append("<div class=\"ui inverted red segment\">#{i18n.registerFailure}</div>")
			)
	return