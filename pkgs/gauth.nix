{ stdenv, fetchurl }:
let
  gauthReleaseExecutable = fetchurl {
    url = "https://github.com/pcarrier/gauth/releases/download/v1.3.0/gauth_1.3.0_linux_amd64";
    sha256 = "sha256-IdLVJq9K0HwYBCMlvalFEqKTy1n4yTj+5y+o3JTOy18=";
  };
in
stdenv.mkDerivation {
  name = "gauth";
  version = "1.3.0";
  src = gauthReleaseExecutable;
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp ${gauthReleaseExecutable} $out/bin/gauth
    chmod +x $out/bin/gauth
  '';
}
