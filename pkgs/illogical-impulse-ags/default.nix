{ lib, stdenv, fetchFromGitHub, gradience, python3, bc, xdg-user-dirs, pywal, dart-sass, makeWrapper }:

stdenv.mkDerivation {
  pname = "illogical-impulse-ags";
  version = "latest";

  src = fetchFromGitHub {
    owner = "bigsaltyfishes";
    repo = "dots-hyprland";
    rev = "f3881b9bcc67edf268c5e68fa6c51c01d7d9fafe";
    sha256 = "sha256-0ihJT6gkb+pTGYVdSySWDTzFEikjgNiQhvt+6+c3rZQ=";
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
