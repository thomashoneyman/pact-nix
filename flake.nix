{
  description = "The Pact smart contract language";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
      pactPkgs = pkgs.callPackages ./versions.nix {};
    in
      pactPkgs // {default = pactPkgs.pact;});

    apps = forAllSystems (
      system: let
        pkgs = nixpkgsFor.${system};
        pactApps =
          pkgs.lib.mapAttrs (name: pact-bin: {
            type = "app";
            program = "${pact-bin}/bin/pact";
          })
          self.packages.${system};
      in
        pactApps // {default = pactApps.pact;}
    );

    devShells = forAllSystems (
      system: let
        pkgs = nixpkgsFor.${system};
      in {
        default = pkgs.mkShell {
          name = "pact-nix-${self.packages.${system}.default.version}";
          buildInputs = [self.packages.${system}.default];
        };
      }
    );

    checks = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
    in
      pkgs.lib.mapAttrs (name: pact-bin:
        pkgs.runCommand "pact" {buildInputs = [pact-bin];} ''
          touch $out
          PACT_VERSION=$(pact --version)
          EXPECTED_VERSION="pact version ${pact-bin.version}"
          echo "$PACT_VERSION should match expected output $EXPECTED_VERSION"
          test "$PACT_VERSION" = "$EXPECTED_VERSION"
        '')
      self.packages.${system});
  };
}
