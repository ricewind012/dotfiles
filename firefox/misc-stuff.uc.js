// ==UserScript==
// @name         Miscellaneous things
// @description  Stuff too small for a dedicated userscript.
// @author       me
// @include      main
// ==/UserScript==

async function DoTheThing() {
	/**
	 * Re-enable Header Editor
	 *
	 * For some reason,
	 * it has to be re-enabled in order to disable CSP.
	**/
	let ext = (await AddonManager.getAllAddons()).find(
		e => e.id == 'headereditor-amo@addon.firefoxcn.net'
	)

	ext.disable()
	setTimeout(() => ext.enable(), 5000)

	/**
	 * Write tab URLs to $XDG_CACHE_HOME/firefox-tabs
	**/
	let file = `${Services.env.get('XDG_CACHE_HOME')}/firefox-tabs`
	let tabs = gBrowser.tabs
		.map(e => e.linkedBrowser)
		.map(e => e._documentURI || e._cachedCurrentURI)
		.map(e => e?.spec)
		.filter(e => e && e.startsWith('http'))
	.join('\n')

	// Firefox has 1 tab when it shits itself
	if (tabs.length && tabs.length >= 2)
		IOUtils.writeUTF8(file, tabs)

	/**
	 * Updates `ui.systemUsesDarkTheme` on press
	**/
	_ucUtils.createWidget({
		id:       'update-theme',
		type:     'toolbarbutton',
		label:    'Update color scheme',
		tooltip:  'Update color scheme',
		image:    'chrome://browser/skin/customize.svg',

		callback: () => _ucUtils.prefs.set(
			'ui.systemUsesDarkTheme',
			_ucUtils.prefs.get('ui.systemUsesDarkTheme').value
				? 0
				: 1
		)
	})

	/**
	 * Hotkeys
	**/
	// F10 - Hide everything
	_ucUtils.registerHotkey(
		{
			id:        'key_minimalUI',
			key:       'F10',
			modifiers: '',
		},
		() => {
			let doc = document.documentElement

			doc.setAttribute(
				'chromehidden',
				doc.getAttribute('chromehidden')
					? ''
					: 'toolbar location'
			)
		}
	)

	// Ctrl+H - Firefox View history
	return
	document.getElementById('key_gotoHistory').setAttribute(
		'oncommand',
		`_ucUtils.loadURI(window, {
			url:   'about:firefoxview-next#history',
			where: 'tab',
		})`
	)
}

Services.obs.addObserver(
	DoTheThing,
	'browser-delayed-startup-finished'
)
