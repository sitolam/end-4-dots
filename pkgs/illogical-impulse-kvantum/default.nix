{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "illogical-impulse-kvantum";
  version = "latest";

  src = fetchFromGitHub {
    owner = "end-4";
    repo = "dots-hyprland";
    rev = "742d84ee866faa26d7c742fc1be8db943bd97bb9";
    sha256 = "sha256-YrMzmM9r7cL3Ks6/Rd8/nyBG6CYyFh79Cyeni8Iof10=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r .config/Kvantum/* $out/

    runHook postInstall
  '';

  postInstall = ''
    mv $out/MaterialAdw/MaterialAdw.svg $out/MaterialAdw/MaterialAdw.svg.sample
    mv $out/MaterialAdw/MaterialAdw.kvconfig $out/MaterialAdw/MaterialAdw.kvconfig.sample
  '';

  meta = {
    description = "Kvantum theme written by end-4";
    homepage = "https://github.com/end-4/dots-hyprland";
    license = lib.licenses.gpl3;
  };
}
