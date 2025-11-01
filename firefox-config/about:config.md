### set these settings on about:config 
docs: #https://librewolf.net/docs/settings/#where-do-i-find-my-librewolfoverridescfg

#####  hardware acceleration
layers.acceleration.force-enabled = true
gfx.direct2d.disabled = false
webgl.disabled = set to false to enable 
    also because if webgl is enabled, there's fingerprinting concerns so by docs its recommend use a canvas blocker plugin (any will do):
    recommend canvas blocker plugin https://addons.mozilla.org/en-US/firefox/addon/canvasblocker/
    see the docs https://librewolf.net/docs/settings/#enable-webgl

##### diable auto translate 
browser.translations.enable = false
intl.accept_languages = EN
intl.locale.requested = EN

##### force browser to use 
ui.systemUsesDarkTheme

##### scroll configs
general.smoothScroll.currentVelocityWeighting: 0

    Controls how much the current scrolling velocity affects the next movement.
    0 means no inertia—scrolling stops immediately when you stop scrolling.

general.smoothScroll.mouseWheel.durationMaxMS: 250

    Sets the maximum duration (in milliseconds) for a single scroll event.
    250ms means the scroll animation completes within 0.25 seconds.

general.smoothScroll.stopDecelerationWeighting: 0.8

    Determines how fast scrolling slows down when you stop scrolling.
    0.82 makes deceleration smoother (lower values stop scrolling more abruptly).

mousewheel.min_line_scroll_amount: 25

    Sets the minimum number of lines scrolled per wheel tick.
    25 makes scrolling significantly faster compared to the default (which is usually 5).

general.smoothScroll.msdPhysics.enabled

    Enables "Mass-Spring-Damper" physics-based smooth scrolling.
    If true, scrolling feels more natural, like a touchscreen flick.
    If false, scrolling behaves more linear (traditional mouse scrolling).


To make Tridactyl work on addons.mozilla.org and some other Mozilla domains
resistFingerprinting.block_mozAddonManager = true, as well as remove those domains from extensions.webextensions.restrictedDomains.
