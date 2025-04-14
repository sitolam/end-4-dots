{ lib, stdenv, fetchFromGitHub, gradience, python3, bc, xdg-user-dirs, pywal, dart-sass, makeWrapper }:

stdenv.mkDerivation {
  pname = "illogical-impulse-ags";
  version = "latest";

  src = fetchFromGitHub {
    owner = "end-4";
    repo = "dots-hyprland";
    rev = "742d84ee866faa26d7c742fc1be8db943bd97bb9";
    sha256 = "sha256-YrMzmM9r7cL3Ks6/Rd8/nyBG6CYyFh79Cyeni8Iof10=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    mkdir -p $out
    cp -r .config/ags/* $out/
  '';

  fixupPhase = ''
    # Wrap all scripts to use the correct environment
    for prog in $(find $out -type f -name "*.sh" -executable); do
      wrapProgram $prog \
        --prefix PATH : ${lib.makeBinPath [ 
          bc
          xdg-user-dirs
          pywal
          dart-sass
          gradience
          (python3.withPackages (p: with p; [
            setproctitle
            materialyoucolor
            material-color-utilities
            pywayland
          ]))
        ]}
    done
  '';

  meta = {
    description = "Illogical Impulse AGS";
    homepage = "https://github.com/end-4/dots-hyprland";
    license = lib.licenses.gpl3;
  };
}
