local monitors = require("monitors")
local apps = require("hyprland.apps")
local hs = require("plugins.hyprsplit")

local main_mod = "SUPER"

for i = 1, num_workspace do
    -- Workspace swtiching and window workspace moving
    hl.bind(main_mod .. " + " .. i, hs.dsp.focus({ workspace = i }))
    hl.bind(main_mod .. " + SHIFT + " .. i, hs.dsp.window.move({ workspace = i }))
end

-- Compositor
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl kill"))
hl.bind(main_mod .. " + M", hl.dsp.exec_cmd("~/.config/hypr/scripts/shutdown.sh"))

-- applications
hl.bind("ALT + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + L", hl.dsp.exec_cmd(lock))
hl.bind(main_mod .. " + R", hl.dsp.exec_cmd(browser))
hl.bind(main_mod .. " + W", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + V", hl.dsp.exec_cmd(cliphist))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.exec_cmd(screenshot))
hl.bind(main_mod .. " + SHIFT + C", hl.dsp.exec_cmd(colorPicker))
hl.bind("CTRL + ALT + delete", hl.dsp.exec_cmd(terminal .. " btop"))

-- window navigation
hl.bind("CTRL + ALT + TAB", hl.dsp.exec_cmd(winoverview))
hl.bind("ALT + Tab", hl.dsp.window.cycle_next({next=true}))
hl.bind(main_mod .. " + Tab", hl.dsp.focus({monitor = "+1"}))
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({next=false}))
hl.bind(main_mod .. " + SHIFT + Tab", hl.dsp.focus({monitor = "-1"}))

-- window management
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(main_mod .. " + S", hl.dsp.layout("togglesplit"))
hl.bind(main_mod .. " + C", hl.dsp.window.float({action = "toggle"}))

-- Group management
hl.bind(main_mod .. " + G", hl.dsp.group.toggle())
hl.bind(main_mod .. " + CTRL + left", hl.dsp.group.prev())
hl.bind(main_mod .. " + CTRL + right", hl.dsp.group.next())
hl.bind(main_mod .. " + SHIFT + G", hl.dsp.window.move({out_of_group = true}))

-- window movement
hl.bind(main_mod .. " + up", hl.dsp.window.move({direction = "u"}))
hl.bind(main_mod .. " + down", hl.dsp.window.move({direction = "d"}))
hl.bind(main_mod .. " + left", hl.dsp.window.move({direction = "l"}))
hl.bind(main_mod .. " + right", hl.dsp.window.move({direction = "r"}))

-- Window resizing
hl.bind(main_mod .. " + SHIFT + up", hl.dsp.window.resize({x = 0, y = -30, relative = true}), { repeating = true })
hl.bind(main_mod .. " + SHIFT + down", hl.dsp.window.resize({x = 0, y = 30, relative = true}), { repeating = true })
hl.bind(main_mod .. " + SHIFT + left", hl.dsp.window.resize({x = -30, y = 0, relative = true}), { repeating = true })
hl.bind(main_mod .. " + SHIFT + right", hl.dsp.window.resize({ x = 30, y = 0, relative = true}), { repeating = true })

hl.bind(main_mod .. " + D", hs.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "+1" }))
hl.bind(main_mod .. " + SHIFT + D", hs.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "-1" }))

-- Scroll through existing workspaces with main_mod + scroll
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))

-- Move/resize windows with main_mod + LMB/RMB and dragging
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- media keys
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume --limit 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume --limit 1 @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
