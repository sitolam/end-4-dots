{ config, pkgs, lib, ... }:
let
  enabled = config.illogical-impulse.enable;
  selfPkgs = import ../pkgs { 
    inherit pkgs; 
    ags = config.illogical-impulse.hyprland.agsPackage; 
  };
  google-fonts = (pkgs.google-fonts.override {
    fonts = [
      "Gabarito"
      "Lexend"
      "Chakra Petch"
      "Crimson Text"
      "Alfa Slab One"
    ];
  });
in
{
  config = lib.mkIf enabled {
    home = {
      packages = with pkgs; with nodePackages_latest; with gnome; with libsForQt5; [
        # gui
        blueberry
        pkgs.nautilus
        xfce.thunar
        yad

        # tools
        ripgrep
        jq
        libnotify
        glib
        foot
        kitty
        smile
        ydotool

        # themes
        selfPkgs.illogical-impulse-oneui4-icons
        adwaita-qt6
        adw-gtk3
        bibata-cursors
        morewaita-icon-theme

        # fonts
        noto-fonts
        noto-fonts-cjk-sans
        google-fonts
        cascadia-code
        material-symbols
      ] ++ (with pkgs.nerd-fonts; [
        # nerd fonts
        ubuntu
        ubuntu-mono
        jetbrains-mono
        caskaydia-cove
        fantasque-sans-mono
        mononoki
        space-mono
      ]);
    };
  };
}
