{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "illogical-impulse-hyprland-shaders";
  version = "latest";

  src = fetchFromGitHub {
    owner = "end-4";
    repo = "dots-hyprland";
    rev = "742d84ee866faa26d7c742fc1be8db943bd97bb9";
    sha256 = "sha256-YrMzmM9r7cL3Ks6/Rd8/nyBG6CYyFh79Cyeni8Iof10=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r $src/.config/hypr/shaders/* $out/
  '';

  meta = {
    description = "Hyprland Shaders written by end-4";
    homepage = "https://github.com/end-4/dots-hyprland";
    license = lib.licenses.gpl3;
  };
}
