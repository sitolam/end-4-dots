{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "illogical-impulse-hyprland-hyprland";
  version = "latest";

  src = fetchFromGitHub {
    owner = "sitolam";
    repo = "dots-hyprland";
    rev = "2b1abe14ee55b9ae4420d4715010a22f6243986c";
    sha256 = "sha256-BLQqw06gao8TDQOPA8c+pSb0vaf+EFG9pM1QpQycLtY=";
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
