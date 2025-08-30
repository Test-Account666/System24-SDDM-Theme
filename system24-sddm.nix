{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  propagatedBuildInputs = [ pkgs.kdePackages.sddm ];
  pname = "system24-sddm";
  version = "1.1.0";

  src = ./system24-sddm;

  installPhase = ''
    mkdir -p $out/share/sddm/themes/system24-sddm
    cp -r * $out/share/sddm/themes/system24-sddm
  '';
}
