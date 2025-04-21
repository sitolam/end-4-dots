{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "illogical-impulse-kvantum";
  version = "latest";

  src = fetchFromGitHub {
    owner = "sitolam";
    repo = "dots-hyprland";
    rev = "ff1ffe0f27a8dcd65beeda485e7e3d5f1e4d2263";
    sha256 = "sha256-sGQDaGY13s5SdHaWR515xoxv3C3aZYRoChKejP2bAG4=";
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
