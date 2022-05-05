{
  description = "The Pact smart contract language";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        versions = pkgs.callPackages ./versions.nix { };
      in {
        packages = versions;
        defaultPackage = versions.pact;

        apps = pkgs.lib.mapAttrs (name: pact-bin: {
          type = "app";
          program = "${pact-bin}/bin/blender";
        }) versions;
        defaultApp = {
          type = "app";
          program = "${versions.pact}/bin/pact";
        };

        checks = pkgs.lib.mapAttrs (name: pact-bin:
          pkgs.runCommand "pact" { buildInputs = [ pact-bin ]; } ''
            touch $out
            PACT_VERSION=$(pact --version)
            EXPECTED_VERSION="pact version ${pact-bin.version}"
            echo "$PACT_VERSION should match expected output $EXPECTED_VERSION"
            test "$PACT_VERSION" = "$EXPECTED_VERSION"
          '') self.packages.${system};
      });
}
