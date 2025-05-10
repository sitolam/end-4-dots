{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "illogical-impulse-hyprland-shaders";
  version = "latest";

  src = fetchFromGitHub {
    owner = "sitolam";
    repo = "dots-hyprland";
    rev = "00c3ef899c9e271559192398265444f02aa2d23a";
    sha256 = "sha256-4vaS3LFWtegh0yChMRbU7X6oe98hZw/+xyWHwlj2/Z4=";
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
