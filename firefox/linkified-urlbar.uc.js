// ==UserScript==
// @name          Linkified URL bar
// @description   Linkify URL segments
// @version       1.0
// @include       main
// ==/UserScript==

/*
 * Originals:
 * https://github.com/sdavidg/firefoxChromeScripts/blob/main/scripts/dav_LinkifiesLocationBar.uc.js
 * https://addons.mozilla.org/en-US/firefox/addon/locationbar%C2%B2/
 * https://github.com/simonlindholm/locationbar2
 */

function HandleLink() {
	let url = gBrowser.currentURI.displaySpec

	urlbarContainer.setAttribute('url', url)
	urlbarLinkified.innerHTML = ''
	urlbarLinkified.hidden = false

	if (
		url.startsWith('about:') ||
		url.startsWith('data:') ||
		url == AboutNewTab._newTabURL
	) {
		urlbarLinkified.hidden = true
		return
	}

	try {
		var {
			protocol,
			hostname,
			port,
			pathname,
			hash,
			search
		} = new URL(url)
	} catch (e) {
		console.log('lol')
		console.log(`${urlbarNormal.value}`)
		urlbarLinkified.innerHTML = url
		return
	}

	if (idnShowPunycode)
		hostname = idn.convertToDisplayIDN(hostname, {})

	let params = search.match(/(\w+)(=(\w+))?/g)
	let split  = hostname.split('.')
	let subdomain

	if (split.length >= 4 && !split.every(e => e == e - 0)) {
		subdomain = split.splice(0, split.length - 2).join('.')
		hostname  = split.join('.')
	}

	AppendPart(protocol, '//', 'protocol')
	AppendPart(subdomain, '.', 'subdomain')
	AppendPart(hostname, '', 'hostname')
	AppendPart(port, ':', 'port', true)
	AppendSlash()

	pathname.split('/').forEach(e => {
		if (!e)
			return

		AppendPart(e, '', 'pathname')
		AppendSlash()
	})
	urlbarLinkified.lastChild.remove()

	if (params) {
		AppendPart(params[0], '?', 'search', true)
		for (let i = 1; i < params.length; i++)
			AppendPart(params[i], '&', 'search', true)
	}
	AppendPart(hash, '', 'hash', true)
}

function AppendPart(
	text,
	additionalText,
	elClass,
	before = false
) {
	if (!text)
		return

	let isProtocol = elClass == 'protocol'
	let el = CreateElement(
		isProtocol ? 'span' : 'a',
		{ class: elClass }
	)
	let elText = before
		? additionalText + text
		: text + additionalText
	if (!isProtocol)
		el.setAttribute(
			'href',
			urlbarLinkified.textContent + (
				elClass == 'subdomain'
					? additionalText + hostname
					: elText
			)
		)
	el.textContent = elText
	el.addEventListener('click', LinkHandler)
	urlbarLinkified.appendChild(el)
}

function AppendSlash() {
	let span = CreateElement('span')

	span.textContent = '/'
	urlbarLinkified.appendChild(span)
}

function LinkHandler(e) {
	if (e.button == 2)
		return

	let target = e.target

	if (target.className == 'protocol')
		return

	let href  = target.getAttribute('href')
	let where = e.button == 1 || e.ctrlKey ? 'tab' : 'current'

	e.view.openLinkIn(href, where, {
		allowThirdPartyFixup:     true,
		targetBrowser:            gBrowser.selectedBrowser,
		indicateErrorPageLoad:    true,
		allowPinnedTabHostChange: true,
		disallowInheritPrincipal: true,
		allowPopups:              false,
		triggeringPrincipal:      Services
			.scriptSecurityManager
			.getSystemPrincipal()
	})

	e.stopPropagation()
}

// style
css = encodeURIComponent(`
#urlbar-linkified {
	white-space: nowrap;
	width: 100%;
	cursor: text;

	/*
	 * The CSS way to detect text overflow on both sides
	 * instead of using #urlbar[textoverflow] in browser.css.
	 */
	&:not([scrolledtostart][scrolledtoend]) {
		mask-image: linear-gradient(
			to right,
			transparent,
			black 3ch,
			black calc(100% - 3ch),
			transparent
		);

		&[scrolledtostart] {
			mask-image: linear-gradient(to left, transparent, black 3ch);
		}

		&[scrolledtoend] {
			mask-image: linear-gradient(to right, transparent, black 3ch);
		}
	}

	a {
		color: inherit !important;

		&:not(:hover) {
			text-decoration: none !important;
		}
	}

	span,
	:not(.hostname, .pathname) {
		color: var(--fg2) !important;
	}
}

.urlbar-input-box {
	align-items: center;
}
#urlbar[focused] #urlbar-linkified {
	display: none !important;
}
`)

let sss = Cc['@mozilla.org/content/style-sheet-service;1']
	.getService(Ci.nsIStyleSheetService)

sss.loadAndRegisterSheet(
	Services.io.newURI(`data:text/css;charset=UTF-8,${css}`),
	sss.AGENT_SHEET
)

// main
let CreateElement = (type, attrs) =>
	_ucUtils.createElement(document, type, attrs)

let urlbarNormal    = gURLBar.inputField
let urlbarContainer = urlbarNormal.parentNode
// No [orient="horizontal"] due to my theme.
let urlbarLinkified = CreateElement(
	'arrowscrollbox',
	{ id: 'urlbar-linkified' }
)
urlbarLinkified.shadowRoot.addEventListener('click', () => {
	urlbarNormal.focus()
})

urlbarContainer.appendChild(urlbarLinkified)

let idn = Cc['@mozilla.org/network/idn-service;1']
	.getService(Ci.nsIIDNService)
let idnShowPunycode = Services.prefs.getBoolPref(
	'network.IDN_show_punycode'
)

Services.obs.addObserver(
	HandleLink,
	'browser-delayed-startup-finished'
)
urlbarNormal.addEventListener(
	'SetURI',
	HandleLink
)
