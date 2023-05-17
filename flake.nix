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

    getPrefix = s:
      if builtins.substring 0 3 s == "kda"
      then "kda"
      else if builtins.substring 0 4 s == "pact"
      then "pact"
      else null;
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
      pact = pkgs.callPackages ./versions-pact.nix {};
      kda = pkgs.callPackages ./versions-kda-tool.nix {};
    in
      kda // pact // {default = pact.pact;});

    apps = forAllSystems (
      system: let
        pkgs = nixpkgsFor.${system};
        apps =
          pkgs.lib.mapAttrs (name: bin: {
            type = "app";
            program = "${bin}/bin/${getPrefix name}";
          })
          self.packages.${system};
      in
        apps // {default = apps.pact;}
    );

    devShells = forAllSystems (
      system: let
        pkgs = nixpkgsFor.${system};
      in {
        default = pkgs.mkShell {
          name = "pact-nix";
          buildInputs = [
            self.packages.${system}.pact
            self.packages.${system}.kda-tool
          ];
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
      (pkgs.lib.filterAttrs (name: value: getPrefix name == "pact") self.packages.${system}));
  };
}
