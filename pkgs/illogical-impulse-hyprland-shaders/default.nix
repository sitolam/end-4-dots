{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "illogical-impulse-hyprland-shaders";
  version = "latest";

  src = fetchFromGitHub {
    owner = "bigsaltyfishes";
    repo = "dots-hyprland";
    rev = "f3881b9bcc67edf268c5e68fa6c51c01d7d9fafe";
    sha256 = "sha256-0ihJT6gkb+pTGYVdSySWDTzFEikjgNiQhvt+6+c3rZQ=";
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
