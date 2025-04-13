{ config, lib, pkgs, ... }:
let
  hypr = config.illogical-impulse.hyprland.package;
  hypr-xdg = config.illogical-impulse.hyprland.xdgPortalPackage;
  selfPkgs = import ../pkgs { 
    inherit pkgs; 
    ags = config.illogical-impulse.hyprland.agsPackage; 
  };
  enabled = config.illogical-impulse.enable;
  hyprlandConf = config.illogical-impulse.hyprland;
in
{
  config = lib.mkIf enabled {
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;
    home.packages = with pkgs; [
      gvfs
      polkit_gnome
      easyeffects
      file-roller
      gnome-text-editor
      gnome-system-monitor
      gnome-control-center
      gnome-tweaks
      brightnessctl
      ddcutil
      cliphist
      fuzzel
      grim
      hyprpicker
      tesseract
      pavucontrol
      playerctl
      swappy
      slurp
      swww
      wl-clipboard
      wf-recorder
    ];

    home.file.".config/hypr/shaders" = {
      source = "${selfPkgs.illogical-impulse-hyprland-shaders}";
    };

    home.file.".config/hypr/hyprland" = {
      source = "${selfPkgs.illogical-impulse-hyprland-hyprland}";
    };


    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;
      xwayland.enable = true;
      package = hypr;
      portalPackage = hypr-xdg;
      settings = {
        env = [
          "GIO_EXTRA_MODULES, ${pkgs.gvfs}/lib/gio/modules:$GIO_EXTRA_MODULES"
          "QT_QPA_PLATFORM, wayland"
          "QT_QPA_PLATFORMTHEME, qt5ct"
        ] ++ (lib.optionals hyprlandConf.ozoneWayland.enable [
          "NIXOS_OZONE_WL, 1"
        ]);
        monitor = hyprlandConf.monitor;
        "exec-once" = [
          "swww-daemon --format xrgb"
          "illogical-impulse-ags-launcher"
          "fcitx5"
          "gnome-keyring-daemon --start --components=secrets"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "systemctl --user start gvfs-daemon.service"
          "systemctl --user start gvfs-udisks2-volume-monitor.service"
          "systemctl --user start gvfs-afc-volume-monitor.service"
          "systemctl --user start gvfs-gphoto2-volume-monitor.service"
          "systemctl --user start gvfs-mtp-volume-monitor.service"
          "systemctl --user start gvfs-metadata.service"
          "hypridle"
          "dbus-update-activation-environment --all"
          "sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "hyprpm reload"
          "easyeffects --gapplication-service"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          "hyprctl setcursor Bibata-Modern-Ice 24"
        ];
        general = {
          # Gaps and border
          gaps_in = 4;
          gaps_out = 5;
          gaps_workspaces = 50;
          border_size = 1;
          
          # Fallback colors
          # "col.active_border" = "rgba(0DB7D4FF)";
          # "col.inactive_border" = "rgba(31313600)";

          resize_on_border = true;
          no_focus_fallback = true;
          layout = "dwindle";

          #focus_to_other_workspaces = true # ahhhh i still haven't properly implemented this
          allow_tearing = true; # This just allows the `immediate` window rule to work
        };
        dwindle = {
          preserve_split = true;
          smart_split = false;
          smart_resizing = false;
        };
        gestures = {
          workspace_swipe = true;
          workspace_swipe_distance = 700;
          workspace_swipe_fingers = 4;
          workspace_swipe_cancel_ratio = 0.2;
          workspace_swipe_min_speed_to_force = 5;
          workspace_swipe_direction_lock = true;
          workspace_swipe_direction_lock_threshold = 10;
          workspace_swipe_create_new = true;
        };
        binds = { scroll_event_delay = 0; };
        input = {
          # Keyboard: Add a layout and uncomment kb_options for Win+Space switching shortcut
          kb_layout = "us";
          # kb_options = grp:win_space_toggle;
          numlock_by_default = true;
          repeat_delay = 250;
          repeat_rate = 35;

          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
            clickfinger_behavior = true;
            scroll_factor = 0.5;
          };

          special_fallthrough = true;
          follow_mouse = 1;
        };
        decoration = {
          rounding = 20;
          active_opacity = 1.0;
          inactive_opacity = 0.8;
          fullscreen_opacity = 1.0;

          blur = {
            enabled = true;
            size = 6;
            passes = 2;
            new_optimizations = "on";
            ignore_opacity = true;
            xray = true;
          };
          
          # Shadow
          shadow = {
            enabled = true;
            range = 30;
            render_power = 3;
            # color = "0x66000000";
          };
        };
        animations = {
          enabled = true;
          bezier = [
            "linear, 0, 0, 1, 1"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "overshot, 0.05, 0.9, 0.1, 1.1"
            "crazyshot, 0.1, 1.5, 0.76, 0.92 "
            "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
            "menu_decel, 0.1, 1, 0, 1"
            "menu_accel, 0.38, 0.04, 1, 0.07"
            "easeInOutCirc, 0.85, 0, 0.15, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
            "softAcDecel, 0.26, 0.26, 0.15, 1"
            "md2, 0.4, 0, 0.2, 1" # use with .2s duration
          ];
          animation = [
            "windows, 1, 3, md3_decel, popin 60%"
            "windowsIn, 1, 3, md3_decel, popin 60%"
            "windowsOut, 1, 3, md3_accel, popin 60%"
            "border, 1, 10, default"
            "fade, 1, 3, md3_decel"
            # "layers, 1, 2, md3_decel, slide"
            "layersIn, 1, 3, menu_decel, slide"
            "layersOut, 1, 1.6, menu_accel"
            "fadeLayersIn, 1, 2, menu_decel"
            "fadeLayersOut, 1, 4.5, menu_accel"
            "workspaces, 1, 7, menu_decel, slide"
            # "workspaces, 1, 2.5, softAcDecel, slide"
            # "workspaces, 1, 7, menu_decel, slidefade 15%"
            # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
            "specialWorkspace, 1, 3, md3_decel, slidevert"
          ];
        };
        misc = {
          vfr = 1;
          vrr = 1;
          animate_manual_resizes = false;
          animate_mouse_windowdragging = false;
          enable_swallow = false;
          swallow_regex = "(foot|kitty|allacritty|Alacritty)";
          
          disable_hyprland_logo = true;
          force_default_wallpaper = 0;
          new_window_takes_over_fullscreen = 2;
          allow_session_lock_restore = true;
          
          initial_workspace_tracking = false;
        };
        bind = [
            "Alt, Tab, bringactivetotop, "
            "Alt, Tab, cyclenext"
            ''
            Ctrl+Alt, Delete, exec, for ((i=0; i<$(hyprctl monitors -j | jq length); i++)); do ags -t"session""$i"; done
            ''
            "Ctrl+Alt, R, exec, ~/.config/ags/scripts/record-script.sh --fullscreen"
            "Ctrl+Alt, Slash, exec, ags run-js 'cycleMode();'"
            "Ctrl+Shift+Alt, Delete, exec, pkill wlogout || wlogout -p layer-shell"
            "Ctrl+Shift+Alt+Super, Delete, exec, systemctl poweroff || loginctl poweroff"
            "Ctrl+Shift, Escape, exec, gnome-system-monitor"
            "Ctrl+Super, Backslash, resizeactive, exact 640 480"
            "Ctrl+Super, BracketLeft, workspace, -1"
            "Ctrl+Super, BracketRight, workspace, +1"
            "Ctrl+Super, Down, workspace, +5"
            ''
            Ctrl+Super, G, exec, for ((i=0; i<$(hyprctl monitors -j | jq length); i++)); do ags -t"crosshair""$i"; done
            ''
            "Ctrl+Super, Left, workspace, -1"
            "Ctrl+Super, L, exec, ags run-js 'lock.lock()'"
            "Ctrl+Super, mouse_down, workspace, -1"
            "Ctrl+Super, mouse_up, workspace, +1"
            "Ctrl+Super, Page_Down, workspace, +1"
            "Ctrl+Super, Page_Up, workspace, -1"
            "Ctrl+Super, Right, workspace, +1"
            "Ctrl+Super+Shift, Left, movetoworkspace, -1"
            "Ctrl+Super+Shift, Right, movetoworkspace, +1"
            ''
            Ctrl+Super+Shift,S,exec,grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract "tmp.png" - | wl-copy && rm "tmp.png"
            ''
            "Ctrl+Super+Shift, Up, movetoworkspacesilent, special"
            "Ctrl+Super+Shift, V, exec, easyeffects"
            "Ctrl+Super, Slash, exec, pkill anyrun || anyrun"
            "Ctrl+Super, S, togglespecialworkspace, "
            "Ctrl+Super, T, exec, ~/.config/ags/scripts/color_generation/switchwall.sh"
            "Ctrl+Super, Up, workspace, -5"
            "Ctrl+Super, V, exec, pavucontrol"
            "Ctrl+Super, W, exec, firefox"
            "Super, 0, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 10"
            "Super, 1, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 1"
            "Super, 2, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 2"
            "Super, 3, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 3"
            "Super, 4, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 4"
            "Super, 5, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 5"
            "Super, 6, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 6"
            "Super, 7, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 7"
            "Super, 8, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 8"
            "Super, 9, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 9"
            "Super, A, exec, ags -t 'sideleft'"
            "Super+Alt, 0, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 10"
            "Super+Alt, 1, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 1"
            "Super+Alt, 2, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 2"
            "Super+Alt, 3, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 3"
            "Super+Alt, 4, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 4"
            "Super+Alt, 5, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 5"
            "Super+Alt, 6, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 6"
            "Super+Alt, 7, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 7"
            "Super+Alt, 8, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 8"
            "Super+Alt, 9, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 9"
            "Super+Alt, E, exec, thunar"
            ''
            Super+Alt, Equal, exec, notify-send"Urgent notification""Ah hell no" -u critical -a 'Hyprland keybind'
            ''
            ''
            Super+Alt, f12, exec, notify-send 'Test notification'"Here's a really long message to test truncation and wrapping\nYou can middle click or flick this notification to dismiss it!" -a 'Shell' -A"Test1=I got it!" -A"Test2=Another action" -t 5000
            ''
            "Super+Alt, F, fullscreenstate, 0 3"
            "Super+Alt, mouse_down, movetoworkspace, -1"
            "Super+Alt, mouse_up, movetoworkspace, +1"
            "Super+Alt, Page_Down, movetoworkspace, +1"
            "Super+Alt, Page_Up, movetoworkspace, -1"
            "Super+Alt, R, exec, ~/.config/ags/scripts/record-script.sh"
            "Super+Alt, Slash, exec, pkill anyrun || fuzzel"
            "Super+Alt, S, movetoworkspacesilent, special"
            "Super+Alt, Space, togglefloating, "
            "Super, B, exec, ags -t 'sideleft'"
            "Super, BracketLeft, movefocus, l"
            "Super, BracketRight, movefocus, r"
            "Super, C, exec, code --password-store=gnome --enable-features=UseOzonePlatform --ozone-platform=wayland"
            "Super, Comma, exec, ags run-js 'openColorScheme.value = true; Utils.timeout(2000, () => openColorScheme.value = false);'"
            "Super, D, fullscreen, 1"
            "Super, Down, movefocus, d"
            "Super, E, exec, nautilus --new-window"
            ", Super, exec, true"
            "Super, F, fullscreen, 0"
            ''
            Super, I, exec, XDG_CURRENT_DESKTOP="gnome" gnome-control-center
            ''
            ''
            Super, K, exec, for ((i=0; i<$(hyprctl monitors -j | jq length); i++)); do ags -t"osk""$i"; done
            ''
            "Super, Left, movefocus, l"
            "Super, L, exec, loginctl lock-session"
            "Super, M, exec, ags run-js 'openMusicControls.value = (!mpris.getPlayer() ? false : !openMusicControls.value);'"
            "Super, mouse:275, togglespecialworkspace, "
            "Super, mouse_down, workspace, -1"
            "Super, mouse_up, workspace, +1"
            "Super, N, exec, ags -t 'sideright'"
            "Super, O, exec, ags -t 'sideleft'"
            "Super, Page_Down, workspace, +1"
            "Super, Page_Up, workspace, -1"
            "Super, Period, exec, pkill fuzzel || ~/.local/bin/fuzzel-emoji"
            "Super, P, pin"
            "Super, Q, killactive, "
            "Super, Return, exec, kitty"
            "Super, Right, movefocus, r"
            "Super+Shift+Alt, mouse:275, exec, playerctl previous"
            ''
            Super+Shift+Alt, mouse:276, exec, playerctl next || playerctl position `bc <<<"100 * $(playerctl metadata mpris:length) / 1000000 / 100"`
            ''
            "Super+Shift+Alt, Q, exec, hyprctl kill"
            "Super+Shift+Alt, R, exec, ~/.config/ags/scripts/record-script.sh --fullscreen-sound"
            ''
            Super+Shift+Alt, S, exec, grim -g "$(slurp)" - | swappy -f -
            ''
            "Super+Shift, C, exec, hyprpicker -a"
            "Super+Shift, Down, movewindow, d"
            "Super+Shift, Left, movewindow, l"
            "Super+Shift, L, exec, loginctl lock-session"
            "Super+Shift, mouse_down, movetoworkspace, -1"
            "Super+Shift, mouse_up, movetoworkspace, +1"
            "Super+Shift, Page_Down, movetoworkspace, +1 "
            "Super+Shift, Page_Up, movetoworkspace, -1 "
            "Super+Shift, Right, movewindow, r"
            "Super+Shift, S, exec, ~/.config/ags/scripts/grimblast.sh --freeze copy area"
            ''
            Super+Shift,T,exec,grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract -l eng "tmp.png" - | wl-copy && rm "tmp.png"
            ''
            "Super+Shift, Up, movewindow, u"
            "Super+Shift, W, exec, wps"
            ''
            Super, Slash, exec, for ((i=0; i<$(hyprctl monitors -j | jq length); i++)); do ags -t "cheatsheet""$i"; done
            ''
            "Super, S, togglespecialworkspace, "
            "Super, Tab, exec, ags -t 'overview'"
            "Super, T, exec, "
            "Super, T, exec, kitty"
            "Super, Up, movefocus, u"
            "Super, V, exec, pkill fuzzel || cliphist list | fuzzel  --match-mode fzf --dmenu | cliphist decode | wl-copy"
            "Super, W, exec, google-chrome-stable"
            "Super, X, exec, gnome-text-editor --new-window"
            "Super, Z, exec, Zed"
          ];
        bindel = [
          "Super+Shift, Comma, exec, ~/.config/ags/scripts/music/adjust-volume.sh -0.03"
          "Super+Shift, Period, exec, ~/.config/ags/scripts/music/adjust-volume.sh 0.03"
        ];
        binde = [
          "Super, Apostrophe, splitratio, +0.1"
          "Super, Equal, splitratio, +0.1"
          "Super, Minus, splitratio, -0.1"
          "Super, Semicolon, splitratio, -0.1"
        ];
        bindir = [
          "Super, Super_L, exec, ags -t 'overview'"
        ];
        bindle = [
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86MonBrightnessDown, exec, ags run-js 'brightness.screen_value -= 0.05; indicator.popup(1);'"
          ", XF86MonBrightnessUp, exec, ags run-js 'brightness.screen_value += 0.05; indicator.popup(1);'"
        ];
        bindl = [
          ",Print,exec,grim - | wl-copy"
          "Super+Shift, B, exec, playerctl previous"
          "Super+Shift, L, exec, sleep 0.1 && systemctl suspend || loginctl suspend"
          "Super+Shift,M,   exec, ags run-js 'indicator.popup(1);'"
          "Super+Shift,M, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%"
          ''
          Super+Shift, N, exec, playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`
          ''
          "Super+Shift, P, exec, playerctl play-pause"
          "Super ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
          ", XF86AudioMute, exec, ags run-js 'indicator.popup(1);'"
          ",XF86AudioMute, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%"
          ''
          ,XF86AudioNext, exec, playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`
          ''
          ",XF86AudioPause, exec, playerctl play-pause"
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioPrev, exec, playerctl previous"
          "Alt ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
          ''
          Ctrl,Print, exec, mkdir -p ~/Pictures/Screenshots && ~/.config/ags/scripts/grimblast.sh copysave screen ~/Pictures/Screenshots/Screenshot_"$(date '+%Y-%m-%d_%H.%M.%S')".png
          ''
        ];
        bindm = [
          "Super, mouse:272, movewindow"
          "Super, mouse:273, resizewindow"
        ];
        bindr = [
          "Ctrl+Super+Alt, R, exec, hyprctl reload; killall ags ydotool; ags &"
          "Ctrl+Super, R, exec, killall ags ydotool; ags &"
        ];
        windowrule = [
          "center, title:^(Choose wallpaper)(.*)$"
          "center, title:^(File Upload)(.*)$"
          "center, title:^(Library)(.*)$"
          "center, title:^(Open File)(.*)$"
          "center, title:^(Open Folder)(.*)$"
          "center, title:^(Save As)(.*)$"
          "center, title:^(Select a File)(.*)$"
          "float,title:^(blueberry.py)$"
          "float,title:^(guifetch)$ "
          "float,title:^(steam)$"
          "float,title:^(Choose wallpaper)(.*)$"
          "float,title:^(File Upload)(.*)$"
          "float,title:^(Library)(.*)$"
          "float,title:^(Open File)(.*)$"
          "float,title:^(Open Folder)(.*)$"
          "float,title:^(Save As)(.*)$"
          "float,title:^(Select a File)(.*)$"
          ''
          immediate,title:.*\.exe
          ''
        ];
        windowrulev2 = [
          "float, title:^(Picture(-| )in(-| )[Pp]icture)$"
          ''
          float, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$
          ''
          "immediate,class:(steam_app)"
          "keepaspectratio, title:^(Picture(-| )in(-| )[Pp]icture)$"
          "move 73% 72%,title:^(Picture(-| )in(-| )[Pp]icture)$ "
          "noshadow,floating:0"
          "pin, title:^(Picture(-| )in(-| )[Pp]icture)$"
          "size 25%, title:^(Picture(-| )in(-| )[Pp]icture)$"
          "tile, class:(dev.warp.Warp)"
        ];
        layerrule = [
          "animation slide left, sideleft.*"
          "animation slide right, sideright.*"
          "blur, bar[0-9]*"
          "blur, cheatsheet[0-9]*"
          "blur, barcorner.*"
          "blur, dock[0-9]*"
          "blur, gtk-layer-shell"
          "blur, indicator.*"
          "blur, indicator.*"
          "blur, launcher"
          "blur, notifications"
          "blur, osk[0-9]*"
          "blur, overview[0-9]*"
          "blur, session"
          "blur, shell:*"
          "blur, sideleft[0-9]*"
          "blur, sideright[0-9]*"
          "ignorealpha 0.5, launcher"
          "ignorealpha 0.69, notifications"
          "ignorealpha 0.6, bar[0-9]*"
          "ignorealpha 0.6, barcorner.*"
          "ignorealpha 0.6, cheatsheet[0-9]*"
          "ignorealpha 0.6, dock[0-9]*"
          "ignorealpha 0.6, indicator.*"
          "ignorealpha 0.6, indicator.*"
          "ignorealpha 0.6, osk[0-9]*"
          "ignorealpha 0.6, overview[0-9]*"
          "ignorealpha 0.6, shell:*"
          "ignorealpha 0.6, sideleft[0-9]*"
          "ignorealpha 0.6, sideright[0-9]*"
          "ignorezero, gtk-layer-shell"
          "noanim, anyrun"
          "noanim, hyprpicker"
          "noanim, indicator.*"
          "noanim, noanim"
          "noanim, osk"
          "noanim, overview"
          "noanim, selection"
          "noanim, walker"
          "xray 1, .*"
        ];
        source = [
          "./hyprland/colors.conf"
        ];
      };

      extraConfig = ''
        plugin {
            hyprexpo {
                columns = 3
                gap_size = 5
                bg_col = rgb(000000)
                workspace_method = first 1 # [center/first] [workspace] e.g. first 1 or center m+1

                enable_gesture = false # laptop touchpad, 4 fingers
                gesture_distance = 300 # how far is the "max"
                gesture_positive = false
            }
        }
      '';
    };

    gtk = {
      enable = true;
      # iconTheme = {
      #   package = pkgs.adwaita-icon-theme;
      #   name = "Adwaita";
      # };
    };
    # qt = {
    #   enable = true;
    #   platformTheme.name = "qt5ct";
    #   style.name = "kvantum";
    # };

    home.file.".config/Kvantum" = {
      source = "${selfPkgs.illogical-impulse-kvantum}";
      recursive = true;
    };
  };
}
