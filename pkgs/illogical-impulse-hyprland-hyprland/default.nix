{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "illogical-impulse-hyprland-hyprland";
  version = "latest";

  src = fetchFromGitHub {
    owner = "sitolam";
    repo = "dots-hyprland";
    rev = "ee5df3fc8e5cfd8d08abddfb3edca36f53b75846";
    sha256 = "sha256-tY+EggivE9FdOZbp1aboM0BhQqzrvBBRlftWgPi/O4g=";
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
