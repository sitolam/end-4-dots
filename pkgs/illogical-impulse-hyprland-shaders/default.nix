{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "illogical-impulse-hyprland-shaders";
  version = "latest";

  src = fetchFromGitHub {
    owner = "sitolam";
    repo = "dots-hyprland";
    rev = "ff1ffe0f27a8dcd65beeda485e7e3d5f1e4d2263";
    sha256 = "sha256-sGQDaGY13s5SdHaWR515xoxv3C3aZYRoChKejP2bAG4=";
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
