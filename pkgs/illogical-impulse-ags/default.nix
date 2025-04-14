{ lib, stdenv, fetchFromGitHub, gradience, python3, bc, xdg-user-dirs, pywal, dart-sass, makeWrapper }:

stdenv.mkDerivation {
  pname = "illogical-impulse-ags";
  version = "latest";

  src = fetchFromGitHub {
    owner = "sitolam";
    repo = "dots-hyprland";
    rev = "b70261b0de8c47731d10e42871eab0be2979fc12";
    sha256 = "sha256-uJzo/VCY7mXl0RMcQ0Y3zS7ZVnHDcWkDClRikwgM29w=";
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
