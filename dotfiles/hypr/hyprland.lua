require("monitors")

require("hyprland.apps")
require("hyprland.rules")
require("plugins.hyprsplit")
require("hyprland.keybinds")
require("hyprland.autostart")
require("hyprland.environment")

hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 8,
        border_size = 1,
        col = {
            inactive_border = "rgba(595959aa)",
            active_border = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
        },
        resize_on_border = true,
        allow_tearing = true,
        layout = "dwindle",
    },
    decoration = {
        rounding = 5,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    group = {
        auto_group = true,
        drag_into_group = 1,
        insert_after_current = true,
        groupbar = {
            height = 14,
            font_size = 12,
            text_offset = 2,
            indicator_gap = 0,
            indicator_height = 3,
            keep_upper_gap = false,
        }
    },
    xwayland = {
        force_zero_scaling = true,
    },
    misc = {
        focus_on_activate = false,
        middle_click_paste = false,
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        mouse_move_focuses_monitor = true,
    },
    cursor = {
        hide_on_touch = true,
        no_hardware_cursors = true,
        sync_gsettings_theme = true,
    },
    debug = {
        full_cm_proto = true,
    }
})

hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })

hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 2,
        sensitivity = 0.0,
        force_no_accel = true,
        accel_profile = "flat",
        touchpad = {
            tap_to_click = true,
            disable_while_typing = true,
        },
    },
})
