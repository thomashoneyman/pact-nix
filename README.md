# Pact Nix

This repository helps you install the [Pact](https://github.com/kadena-io/pact) smart contract programming language without having to build it from source.

## Installation

If you use Nix flakes, you can add this repository as an input:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    pact-nix.url = "github:thomashoneyman/pact-nix/main";
  };

  outputs = { nixpkgs, pact-nix, ... }: { ... };
}
```

If not, you can fetch the packages in this repository via `fetchFromGitHub`:

```nix
{ pkgs }:

let
  pact-nix = import
    (pkgs.fetchFromGitHub {
      owner = "thomashoneyman";
      repo = "pact-nix";
      rev = "5716cd791c999b3246b4fe173276b42c50afdd8d";
      sha256 = "1r9lx4xhr42znmwb2x2pzah920klbjbjcivp2f0pnka7djvd2adq";
    }) {
    inherit pkgs;
  };

in
  { ... }
```

You can get the `rev` and `sha256` for the latest commit in the repository with:

```console
$ nix-prefetch-git https://github.com/thomashoneyman/pact-nix
```

Copy and paste the resulting `rev` and `sha256` into your Nix code where you import `pact-nix`.

## Usage

Once you have `pact-nix` from this repository you can use the overlay to put all Pact versions into your `pkgs`, or you can use `pact-nix` to refer to a specific binary.

For example, using the overlay will put all Pact versions into your `pkgs`. Here it is in a Nix flake:

```nix
{ outputs = { nixpkgs, pact-nix, ... }:
    let
      pkgs = import nixpkgs { overlays = [ pact-nix.overlay ]; };
    in
      { devShell = pkgs.mkShell { buildInputs = [ pkgs.pact ]; };
      }
}
```

The `pact` binary tracks the latest available version, but you can also refer to a specific version of Pact. Here's an example of using `pact-nix` to refer to a specific binary, in a non-Flakes file:

```nix
# shell.nix
{ pkgs }:

let
  pact-nix = { ... }; # See installation instructions above.

in
pkgs.mkShell
  { buildInputs = [ pkgs.pact-4_2_1 ];
  }
```
