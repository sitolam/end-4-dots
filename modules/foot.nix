{ config, lib, ... }:
let
  enabled = config.illogical-impulse.enable;
in
{
  config = lib.mkIf enabled {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          shell = "zsh";
          term = "xterm-256color";
          title = "foot";
          # font = "SpaceMono Nerd Font:size=11";
          letter-spacing = 0;
          dpi-aware = "no";
          pad = "25x25";
          bold-text-in-bright = "no";
        };
        scrollback = {
          lines = 10000;
        };
        cursor = {
          style = "beam";
          blink = "no";
          beam-thickness = 1.5;
        };
        key-bindings = {
          scrollback-up-page = "Page_Up";
          scrollback-down-page = "Page_Down";
          clipboard-copy = "Control+c";
          clipboard-paste = "Control+v";
          search-start = "Control+f";
        };
        search-bindings = {
          cancel = "Escape";
          find-prev = "Shift+F3";
          find-next = "F3 Control+G";
        };
      };
    };
  };
}