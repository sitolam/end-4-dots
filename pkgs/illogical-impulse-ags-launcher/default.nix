{ lib, stdenv, fish, ollama, ags, gradience, python3, bc, xdg-user-dirs, pywal, dart-sass, makeWrapper }:

stdenv.mkDerivation {
  pname = "illogical-impulse-ags-launcher";
  version = "latest";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 illogical-impulse-ags-launcher $out/bin/illogical-impulse-ags-launcher
  '';

  fixupPhase = ''
    wrapProgram $out/bin/illogical-impulse-ags-launcher \
      --prefix PATH : ${lib.makeBinPath [ 
        fish
        ollama
        ags
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
          psutil
        ]))
      ]}
  '';

  meta = {
    description = "Illogical Impulse AGS Launcher";
    homepage = "https://github.com/end-4/dots-hyprland";
    license = lib.licenses.gpl3;
    mainProgram = "illogical-impulse-ags";
  };
}