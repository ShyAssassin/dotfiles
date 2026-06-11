-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.layer_rule({
    blur = true,
    no_anim = true,
    name = "vicinae",
    ignore_alpha = 0,
    match = { namespace = "vicinae" },
})

hl.window_rule({
    name = "proton",
    border_size = 0,
    immediate = true,
    monitor = "DP-5",
    content = "game",
    fullscreen = true,
    workspace = "r~5 silent",
    match = { class = "^(.*steam_app.*)$" },
})

hl.window_rule({
    name = "gscope",
    content = "game",
    monitor = "DP-5",
    immediate = true,
    fullscreen = true,
    border_size = 0,
    workspace = "r~5 silent",
    match = { class = "^(gamescope)$" },
})

-- Misc stuff
hl.window_rule({ match = { class = "(vesktop)" }, center = true })
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ match = { class = "(xdg-desktop-portal-gtk)" }, float = true })
hl.window_rule({ match = { title = "^(.*VNyan.*)$" }, tile = true, size = "1266 1034" })
hl.window_rule({ match = { title = "(Select what to share)" }, float = true, size = "800 450" })
hl.window_rule({ match = { class = "(org.gnome.NautilusPreviewer)" }, float = true, center = true, border_size = 0 })

-- Development stuff
hl.window_rule({ match = { class = "(code)" }, tile = true, center = true })
hl.window_rule({ match = { title = "^(.*Pregen.*)$" }, float = true, center = true })
hl.window_rule({ match = { title = "^(.*Web Inspector.*)$" }, float = true, border_size = 0 })

-- Steam
hl.window_rule({ match = { class = "(steam)", title = "(Game Server)" }, float = true })
hl.window_rule({ match = { class = "(steam)", title = "(Friends List)" }, float = true })
hl.window_rule({ match = { class = "(steam)", title = "(Special Offer)" }, float = true })
hl.window_rule({ match = { class = "(steam)", title = "(Steam Settings)" }, float = true })
hl.window_rule({ match = { class = "(steam)", title = "(Recordings & Screenshots)" }, float = true })
hl.window_rule({ match = { class = "(steam)", title = "(Steam Big Picture Mode)" }, fullscreen = true })

hl.window_rule({
    pin = true,
    float = true,
    center = true,
    name = "polkit",
    stay_focused = true,
    match = { title = "^(.*Polkit.*)$" },
})

hl.window_rule({
    name = "yubico",
    pin = true,
    float = true,
    center = true,
    border_size = 0,
    size = "1020 750",
    no_screen_share = true,
    match = { class = "(yubioath-flutter)" },
})

hl.window_rule({
    pin = true,
    float = true,
    border_size = 0,
    name = "ff-popout",
    match = { class = "(firefox)", title = "(Picture-in-Picture)" },
})
