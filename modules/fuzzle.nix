{ config, lib, ... }:
let
  enabled = config.illogical-impulse.enable;
in
{
  config = lib.mkIf enabled {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          # font = "Gabarito";
          terminal = "foot -e";
          prompt = ">>  ";
          layer = "overlay";
        };
        
        colors = {
          # background = "1D1011ff";
          # text = "F7DCDEff";
          # selection = "574144ff";
          # selection-text = "DEBFC2ff";
          # border = "574144dd";
          # match = "FFB2BCff";
          # selection-match = "FFB2BCff";
        };
        
        border = {
          radius = 17;
          width = 1;
        };
        
        dmenu = {
          exit-immediately-if-empty = "yes";
        };
      };
    };
  };
}