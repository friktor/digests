define [
	"jquery",
	"masonry"
	], ($, Masonry) ->
		"use strict";

		target = new Masonry document.querySelector(".tape.habs .row"),
			itemSelector: ".page.habs .tape.habs .row .col-md-6"
			columnWidth: ".page.habs .tape.habs .row .col-md-6"

		return