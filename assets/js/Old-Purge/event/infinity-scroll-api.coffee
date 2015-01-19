getPosts = (options, i18n) ->
	defaults = 
		# @title template after append
		title_template: "{{title}} ● Me Digests ● {{page}} #{i18n.page}"
		title: "Name page"

		# @this page
		page: 1
		
		# @ajax
		dataType: "json"
		data: 
			render: true

	settings = _.merge defaults, options

	new Promise (resolve, reject) ->
		$.ajax

			# @main options
			dataType: settings.dataType
			data: _.merge( settings.data, page: (settings.page+1) )	
			url: options.url
			type: "GET"

			# @success callback event
			success: (data, textStatus) ->
				if data and data[0]
					
					# @Render AJAX
					render = (data) -> 
						new EJS(url: "/templates/posts.ejs")
							.render(posts: data)

					# History and title update
					replaceTitlePage = (page, locale) ->
						# @endUrl for history
						endUrl = "#{settings.url}/#{settings.data.page}"
						if settings.data.locale
							endUrl+="?locale=#{settings.data.locale}"

						# @title
						titleParse = ((template, title, nextpage) ->
							renderTitle = template.replace "{{title}}", title
							renderPage = renderTitle.replace "{{page}}", nextpage

							return renderPage
						)(settings.title_template, settings.title, (settings.page+1))

						# @apply
						window.history.pushState {}, $("title").text(), endUrl
						$("title").empty().append titleParse
						return
					
					# @jqOBJ with html
					compiled = $ render(data)

					# @title update
					replaceTitlePage()

					# Append Itens
					$(".row.posts_").append(compiled)
						.masonry("appended", compiled)
						.masonry("reloadItems")
						.masonry()

					resolve()

					return

			error: (jqXHR, textStatus, thrown) ->
				console.log "status:: #{textStatus}\n thrown:: #{thrown}\n"
				reject(thrown)
				return

		return



$(document).ready ->

	# $(".b-share__text").each (c, elem) ->
	# 	$(this).prepend "<i class=\"ifc-speech_bubble\"></i> "
	# 	return
	# Pre Init masonry
	masonry_ = 
		itemSelector: ".post"
		columnWidth: ".post"
		isAnimated: true
		andimationOptions: 
			duration: 400
			easing: "swing"
			queue: false
			

	# $(".post img").addClass("not-loaded")
	$(".row.posts_").masonry(masonry_) 
	
	$(".post img.not-loaded").lazyload
		effect: "fadeIn"
		load: ->
			$(this).removeClass(".not-loaded")
			$(".row.posts_").masonry("reloadItems").masonry()
			return
			
	$.getScript "http://cdn.jsdelivr.net/jquery.lazyload/1.8.4/jquery.lazyload.js", ->
		$(".row.posts_").imagesLoaded ->
			$(".row.posts_").masonry("reloadItems").masonry()
			return
		return	

	# Event ajax load posts


	# @PAGE: Latest (newest) posts page
	# @ID: #latest_page
	$('.load.posts').click ->
		$(".row.posts_").masonry("reloadItems").masonry()
		
		options = 
			url: $(this).data("url")
			title: i18n.title
			page: page
			data: {}

		if (locale isnt null)
			options.data.locale = locale 

		getPosts(options, i18n)

		.then(->
			page+=1
			return
		)

		.caught((error) ->
			$(".row.posts_").masonry("reloadItems").masonry()
			if error is "Not Found"
				$(".alert.message").empty().append("<div class=\"ui inverted green segment\" style=\"visibility: hidden; background: #99CC00 !important; \">#{i18n.notFound}</div>")
				
				$(".alert.message .green.segment").css
					"margin-bottom": "15px"
					"border-radius": "0"

				$(".alert.message .green.segment").transition("fade up")
				return
			
			return
		)

	return