module.exports =
	whiteList :
		a: ['target', 'href', 'title', "class"]
		abbr: ['title']
		address: []
		area: ['shape', 'coords', 'href', 'alt']
		article: []
		aside: []
		audio: ['autoplay', 'controls', 'loop', 'preload', 'src']
		b: []
		bdi: ['dir']
		bdo: ['dir']
		big: []
		blockquote: ['cite']
		br: []
		caption: []
		center: []
		cite: []
		code: ["class"]
		col: ['align', 'valign', 'span', 'width']
		colgroup: ['align', 'valign', 'span', 'width']
		dd: []
		del: ['datetime']
		details: ['open']
		div: ["class", "style"]
		dl: []
		dt: []
		em: []
		font: ['color', 'size', 'face']
		footer: []
		h1: []
		h2: []
		h3: []
		h4: []
		h5: []
		h6: []
		header: []
		hr: []
		i: ["class"]
		img: ['src', 'alt', 'title', 'width', 'height', "class"]
		ins: ['datetime']
		li: []
		mark: []
		nav: []
		ol: []
		p: ["class", "style"]
		pre: ["class", "style"]
		s: []
		section:[]
		small: []
		span: ["class", "style"]
		sub: []
		sup: []
		strong: []
		table: ['width', 'border', 'align', 'valign', "class"]
		tbody: ['align', 'valign']
		td: ['width', 'colspan', 'align', 'valign']
		tfoot: ['align', 'valign']
		th: ['width', 'colspan', 'align', 'valign']
		thead: ['align', 'valign']
		tr: ['rowspan', 'align', 'valign']
		tt: []
		u: []
		ul: []
		video: ['autoplay', 'controls', 'loop', 'preload', 'src', 'height', 'width']


	# Options for XSS protect content && sinopsis
	HtmlProtect:
		whiteList:
			a: ["href", "title", "target"], #link
			div: ["data-animate"], p: [], #text 
			h2: [], h3: [], h4: [], #headers
			ul: [], ol: [], li: [], #list
			code: ["data-schema"], #code

		stripIgnoreTagBody: ["script"], # remove from text
		stripIgnoreTag: true, # @boolean

	# XSS protect title - to plain text
	plainText :
		stripIgnoreTagBody: ["script"]
		stripIgnoreTag: true
		whiteList: []