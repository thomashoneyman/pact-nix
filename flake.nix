{
  description = "The Pact smart contract language";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };

      in {
        defaultPackage = self.packages.${system}.pact;
        packages = {
          pact = self.packages.${system}.pact-4_3;
        } // pkgs.callPackages ./versions.nix { };
      });
}
