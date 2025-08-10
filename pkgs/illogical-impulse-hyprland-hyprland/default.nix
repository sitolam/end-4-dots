{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "illogical-impulse-hyprland-hyprland";
  version = "latest";

  src = fetchFromGitHub {
    owner = "sitolam";
    repo = "dots-hyprland";
    rev = "5c9cb1fcf4b254c43b2d2ed4c4737b2c19013553";
    sha256 = "sha256-/2Y3Jdb2fyMHZT8ZCLaxyxKQr+2/RwkDYQqfX9Da4z0=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r $src/.config/hypr/hyprland/* $out/
  '';

  meta = {
    description = "Hyprland hyprland configs written by end-4";
    homepage = "https://github.com/end-4/dots-hyprland";
    license = lib.licenses.gpl3;
  };
}
