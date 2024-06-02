// ==UserScript==
// @name         Replace window title
// @description  ..to "Firefox - CONTENTTITLE".
// @author       me
// @include      main
// @include      chrome://devtools/content/framework/toolbox-window.xhtml
// ==/UserScript==

let doc   = document.documentElement
let delim = getComputedStyle(doc)
	.getPropertyValue('--delim')
	.replace(/["']/g, '') || ' - '

if (
	typeof AppConstants == 'object' &&
	location.href == AppConstants.BROWSER_CHROME_URL
) {
	let name  = AppConstants.MOZ_APP_DISPLAYNAME_DO_NOT_USE
	let title = `${name}${delim}CONTENTTITLE`

	doc.setAttribute('data-content-title-default', title)
	doc.setAttribute('data-content-title-private', title)
} else { // devtools
	Services.obs.addObserver(
		e => {
			if (document.title.startsWith('DevTools'))
				return

			document.title = `DevTools${delim}${document.title.replace('Developer Tools — ', '')}`
		},
		'devtools-thread-ready'
	)
}
