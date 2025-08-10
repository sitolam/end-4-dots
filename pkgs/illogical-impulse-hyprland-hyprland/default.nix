{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "illogical-impulse-hyprland-hyprland";
  version = "latest";

  src = fetchFromGitHub {
    owner = "sitolam";
    repo = "dots-hyprland";
    rev = "a39eb8971e1233d0f1ff47c911a946e9401e7a35";
    sha256 = "sha256-6bhUyCCYKTk0qFh0lNyLQ6dxTKP28QQiHoqnDjg6B6A=";
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
