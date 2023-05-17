{
  stdenv,
  lib,
  fetchzip,
  gmp,
  zlib,
  openssl_1_1,
  pkgs,
}: let
  mkKdaToolDerivation = {
    version,
    src,
  }:
    stdenv.mkDerivation rec {
      pname = "kda";
      inherit version src;

      nativeBuildInputs = [] ++ lib.optional (!stdenv.isDarwin) [pkgs.autoPatchelfHook];
      buildInputs = [gmp zlib openssl_1_1];

      installPhase = ''
        install -m755 -D kda $out/bin/kda
      '';

      meta = {
        description = "Kadena CLI tool for Pact development";
        homepage = "https://github.com/kadena-io/kda-tool";
        license = lib.licenses.bsd3;
      };
    };

  # When a new KDA tool version comes out, this must be updated.
  kda-tool-latest = "kda-tool-1_1";

  kda-tool-versions = {
    # To update, copy/paste the derivation, update the version number, and set
    # the sha256 fields to empty strings. When you attempt to build the
    # derivation, Nix will tell you the correct sha256 to use.
    kda-tool-1_1 = mkKdaToolDerivation rec {
      version = "1.1";
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/kda-tool/releases/download/${version}/kda-tool-${version}-macOS.zip";
            sha256 = "sha256-hHYInr5ww4KRGu06bwnh/rjFrqcRf5UFxTaNrXtO7aI=";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/kda-tool/releases/download/${version}/kda-tool-${version}-ubuntu-20.04.zip";
            sha256 = "sha256-aDeGUwULeoGblFbQqvoz+PLXgmZOMEr4W0BrgBJaMDE=";
            stripRoot = true;
          };
    };
  };
in
  kda-tool-versions // {kda-tool = kda-tool-versions.${kda-tool-latest};}
