$(document).ready ->
	
	# Use tabular in textarea
	$("textarea").keydown (e) ->
	  if e.keyCode is 9 # tab was pressed
	    # get caret position/selection
	    start = @selectionStart
	    end = @selectionEnd
	    $this = $(this)
	    value = $this.val()
	    
	    # set textarea value to: text before caret + tab + text after caret
	    $this.val value.substring(0, start) + "\t" + value.substring(end)
	    
	    # put caret at right position again (add one for the tab)
	    @selectionStart = @selectionEnd = start + 1
	    
	    # prevent the focus lose
	    e.preventDefault()
	  return


	# Markdown parse init;
	markdown = new Remarkable "full",
		langPrefix: "language-"
		typographer: true
		xhtmlOut: false
		linkify: true
		breaks: true
		html: true
		quotes: '“”‘’'

		# integrate hightlight.js to Code.
		highlight: (str, lang) ->
			if lang and hljs.getLanguage(lang)
				try
					return hljs.highlight(lang, str).value
				catch e
					console.log e
			try
				return hljs.highlightAuto(str).value
			catch e
				console.log e

			return ""

	# Main event
			
	# Init modal window plugin
	$(".ui.long.modal").modal()

	# Init checkbox plugin
	$(".ui.checkbox").checkbox()

	# Init dropdown plugin
	$(".ui.selection.dropdown").dropdown()

	# event view rendered preview block
	$(".previewAction").click ->
		content = markdown.render nameValue "content"
		title = nameValue "title"
		img = nameValue "heading"

		# render && append main data
		$(".ContentBlock").empty().append content
		$(".TitleBlock").empty().append title

		# Empty Image and append other
		$(".TitleBlock").parent().find("img").remove()
		$(".TitleBlock").before "<img src=\"#{img}\">"

		$(".ui.long.modal").modal "show"

		return

	$(".addAction").click ->
		draft = $(".ui.checkbox.draftState").checkbox("is checked")
		img = nameValue "heading"

		content = nameValue "content"
		locale = nameValue "locale"
		author = nameValue "author"
		title = nameValue "title"
		hab = nameValue "hab"
		tags = nameValue "tags"


		sendPost = (data) ->
			new Promise (resolve, reject) ->
				$.post("/utils/post/create", data)
					.success((data, textStatus) ->
						resolve data
						return
					)
					.error((xhr, textStatus, error) ->
						reject error
						return
					)
				return

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

		sendPost(
			content: content
			header_img: img
			locale: locale
			author: author
			title: title
			draft: draft
			hab: hab 
			tags: tags

			_csrf: csrf
		)

		.then((data) ->
			$("#alert_message").empty().before "<div class=\"ui inverted blue segment\"><i class=\"ifc-checkmark\"></i> #{i18n.success}</div>"
			setTimeout(->
				window.history.pushState {}, $("title").html(), window.location.toString()
				window.location.replace "/details/#{data.post.id}"
				return
			, 1500)
			return
		)

		.caught((err) ->
			console.log err

			$("#alert_message").empty().before "<div class=\"ui inverted red segment\"><i class=\"ifc-error\"></i> #{i18n.error_try_again}</div>"
			return
		)

		return

	return
