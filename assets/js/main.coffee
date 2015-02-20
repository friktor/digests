$(document).ready ->
	
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

	return