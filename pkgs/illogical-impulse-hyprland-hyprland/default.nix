{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "illogical-impulse-hyprland-hyprland";
  version = "latest";

  src = fetchFromGitHub {
    owner = "bigsaltyfishes";
    repo = "dots-hyprland";
    rev = "6ce7d07b5b0d26afff64002341fbfcfde0e02369";
    sha256 = "sha256-yJf/B7ZT3Y9Is7xMoVnvZZl/qBWxn7BLpz9Ab6v7Hys=";
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
