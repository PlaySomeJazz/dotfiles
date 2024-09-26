user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.backspace_action", 0);
user_pref("browser.cache.disk.enable", false);
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.preferences.defaultPerformanceSettings.enabled", false);
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.sessionstore.resume_from_crash", false);
user_pref("browser.startup.couldRestoreSession.count", 2);
user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");
user_pref("browser.translations.panelShown", true);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.warnOnQuitShortcut", false);
user_pref("extensions.pocket.enabled", false);
user_pref("general.smoothScroll", false);
user_pref("gfx.webrender.all", true);
user_pref("gfx.x11-egl.force-enabled", true);
user_pref("layout.css.prefers-color-scheme.content-override", 0);
user_pref("layout.spellcheckDefault", 0);
user_pref("media.ffmpeg.vaapi-drm-display.enabled", true);
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.ffvpx.enabled", false);
user_pref("media.hardware-video-decoding.force-enabled", true);
user_pref("media.rdd-vpx.enabled", false);
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);
user_pref("mousewheel.system_scroll_override.enabled", false);
user_pref("network.protocol-handler.expose.magnet", false);
user_pref("signon.firefoxRelay.feature", "disabled");
user_pref("signon.management.page.breach-alerts.enabled", false);
user_pref("toolkit.telemetry.pioneer-new-studies-available", false);
user_pref("webgl.disabled", true);
user_pref("accessibility.force_disabled", 1);
user_pref("identity.fxaccounts.enabled", false);
user_pref("ui.context_menus.after_mouseup", true);

/** TELEMETRY ***/
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);

/****************************************************************************
 * SECTION: FASTFOX                                                         *
****************************************************************************/
/** GENERAL ***/
user_pref("content.notify.interval", 100000);

/** GFX ***/
user_pref("gfx.canvas.accelerated.cache-items", 4096);
user_pref("gfx.canvas.accelerated.cache-size", 512);
user_pref("gfx.content.skia-font-cache-size", 20);

/** DISK CACHE ***/
user_pref("browser.cache.jsbc_compression_level", 3);

/** MEDIA CACHE ***/
user_pref("media.memory_cache_max_size", 65536);
user_pref("media.cache_readahead_limit", 7200);
user_pref("media.cache_resume_threshold", 3600);

/** IMAGE CACHE ***/
user_pref("image.mem.decode_bytes_at_a_time", 32768);

/** NETWORK ***/
user_pref("network.http.max-connections", 1800);
user_pref("network.http.max-persistent-connections-per-server", 10);
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5);
user_pref("network.http.pacing.requests.enabled", false);
user_pref("network.dnsCacheExpiration", 3600);
user_pref("network.ssl_tokens_cache_capacity", 10240);

/** SPECULATIVE LOADING ***/
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);
user_pref("network.prefetch-next", false);
user_pref("network.predictor.enabled", false);
user_pref("network.predictor.enable-prefetch", false);

/** EXPERIMENTAL ***/
user_pref("dom.enable_web_task_scheduling", true);
