// Features
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("svg.context-properties.content.enabled", true);
user_pref("layout.css.backdrop-filter.enabled", true);
user_pref("layout.css.has-selector.enabled", true);
user_pref("layout.css.color-mix.enabled", true);
user_pref("browser.compactmode.show", true);

// Unsorted
user_pref("media.av1.enabled", false);
user_pref("browser.backspace_action", 0);
user_pref("accessibility.force_disabled", 1);
user_pref("reader.parse-on-load.enabled", false);
user_pref("browser.menu.showViewImageInfo", true);
user_pref("browser.tabs.unloadOnLowMemory", true);

// UI
user_pref("widget.non-native-theme.scrollbar.size.override", 16);
user_pref("widget.non-native-theme.scrollbar.style", 4);
user_pref("ui.skipNavigatingDisabledMenuItem", 0);
user_pref("ui.key.menuAccessKey", 0);
user_pref("ui.tooltip.delay_ms", 250);
user_pref("ui.scrollToClick", 1);

// Telemetry
user_pref("toolkit.telemetry.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("datareporting.healthreport.documentServerURI", "http://%(server)s/healthreport/");
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionPolicyBypassNotification", true);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);

// Startup
user_pref("browser.startup.blankWindow", false);
user_pref("browser.startup.preXulSkeletonUI", false);

// Updates
user_pref("app.update.suppressPrompts", true);
user_pref("browser.startup.homepage_override.mstone", "ignore");

// Search
/// Don't search until a search keyword is used
user_pref("keyword.enabled", false);
user_pref("browser.urlbar.speculativeConnect.enabled", false);

// Settings
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.preferences.moreFromMozilla", false);
user_pref("extensions.getAddons.showPane", false);

// Extensions
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.screenshots.disabled", true);
user_pref("extensions.screenshots.upload-disabled", true);

// Private browsing
user_pref("browser.privatebrowsing.enable-new-indicator", false);
user_pref("browser.theme.dark-private-windows", false);

// Devtools
user_pref("devtools.accessibility.enabled", false);
user_pref("devtools.application.enabled", false);
user_pref("devtools.performance.enabled", false);
user_pref("devtools.memory.enabled", false);

user_pref("devtools.inspector.showUserAgentStyles", true);
user_pref("devtools.inspector.showAllAnonymousContent", true);

// Fullscreen
user_pref("full-screen-api.transition-duration.enter", 0);
user_pref("full-screen-api.transition-duration.leave", 0);
user_pref("full-screen-api.warning.timeout", 0);

// fuck you
user_pref("browser.newtab.url", "file:///mnt/A29E6A309E69FCE3/linux/etc/startpage/index.html");
user_pref("ui.systemUsesDarkTheme", 0);
