local hs = require("plugins.hyprsplit")
local handle = io.popen("hostname")
local hostname = handle:read("*a")

hostname = hostname:gsub("^%s*(.-)%s*$", "%1")
if hostname == "miyabi" then
    num_monitors = 3
    num_workspace = 5
    primary_monitor = "DP-5"

    hl.monitor({
        scale = 1.0,
        position = "1080x1584",
        mode = "1920x1080@239.96",
        output = "desc:BNQ ZOWIE XL LCD EBD7M03671SL0",
    })
    hl.monitor({
        scale = 1.0,
        transform = 1,
        position = "0x845",
        mode= "1920x1080@60.0",
        output = "desc:LG Electronics 24GM79G 0x00000ECF",
    })
    hl.monitor({
        scale = 1.0,
        position = "3000x1578",
        mode = "2560x1080@60.0",
        output = "desc:LG Electronics LG ULTRAWIDE 0x00000619",
    })
else
    num_monitors = 1
    num_workspace = 10
    hl.notification.create({
        icon = 2,
        duration = "2500",
        color = "rgb(fede05)",
        text = "Unknown host guessing",
    })
end


hs.config({
    persistent_workspaces = true,
    force_monitor_priority = true,
    num_workspaces = num_workspace,
})

hl.config({
    cursor = {
        hide_on_touch = true,
        no_hardware_cursors = 2,
        default_monitor = default_monitor,
    }
})

-- TODO: rerun on wake / unlock
hl.exec_cmd("xrandr --output " .. primary_monitor .. " --primary")
