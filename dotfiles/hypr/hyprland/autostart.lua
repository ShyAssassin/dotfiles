hl.on("hyprland.start", function ()
    hl.exec_cmd("dunst")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("devnotify")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("vicinae server")
    hl.exec_cmd("~/.config/hypr/scripts/xdg.sh")
    hl.exec_cmd("systemctl --user start arRPC")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("hyprctl notify 5 2575 'rgb(E60B83)' 'fontsize:16 [Hyprland] Config loaded successfully'")
end)

-- Shutdown script
-- hl.exec_shutdown("~/.config/hypr/scripts/shutdown.sh")

