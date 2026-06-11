-- needed for nvidia
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- XDG gets confused sometimes
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- enable nvidia features
hl.env("PROTON_ENABLE_NVAPI", "1")
hl.env("VKD3D_CONFIG", "dxr11,dxr")
hl.env("PROTON_ENABLE_NGX_UPDATER", "1")

-- Miscaleanous
hl.env("NIXOS_OZONE_WL", "1")
hl.env("ROFI_VSCODE_FLAVOR", "code")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Theme
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("GTK_THEME", "Tokyonight-Dark")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XCURSOR_THEME", "phinger-cursors-dark")
hl.env("HYPRCURSOR_THEME", "phinger-cursors-dark")
-- hl.exec_once("dbus-update-activation-environment --systemd --all")
-- hl.exec_once("systemctl --user import-environment QT_QPA_PLATFORMTHEME")
-- hl.exec_once("dconf write /org/gnome/desktop/interface/cursor-size 24")
-- hl.exec_once("dconf write /org/gnome/desktop/interface/icon-theme \"'breeze'\"")
-- hl.exec_once("dconf write /org/gnome/desktop/interface/color-scheme \"'prefer-dark'\"")
-- hl.exec_once("dconf write /org/gnome/desktop/interface/gtk-theme \"'Tokyonight-Dark'\"")
-- hl.exec_once("dconf write /org/gnome/desktop/interface/font-name \"'Sans Serif Normal 10'\"")
-- hl.exec_once("dconf write /org/gnome/desktop/interface/cursor-theme \"'phinger-cursors-dark'\"")
-- hl.exec_once("dconf write /org/gnome/desktop/interface/document-font-name \"'Sans Serif Normal 10'\"")
-- hl.exec_once("dconf write /org/gnome/desktop/interface/monospace-font-name \"'JetBrainMonoNL Nerd Font Regular 10'\"")

-- -- Default apps
-- hl.exec_once("xdg-mime default vlc.desktop video/mp4")
-- hl.exec_once("xdg-mime default nvim.desktop text/plain")
-- hl.exec_once("xdg-mime default firefox.desktop text/html")
-- hl.exec_once("xdg-mime default firefox.desktop x-scheme-handler/http")
-- hl.exec_once("xdg-mime default firefox.desktop x-scheme-handler/https")
-- hl.exec_once("xdg-mime default kitty.desktop x-scheme-handler/terminal")
-- hl.exec_once("xdg-mime default org.gnome.Nautilus.desktop inode/directory")
