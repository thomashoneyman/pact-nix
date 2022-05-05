# Pact Nix

[![CI](https://github.com/thomashoneyman/pact-nix/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/thomashoneyman/pact-nix/actions/workflows/ci.yml)

> **WARNING**: This repo is unstable and experimental. Please file an issue if you have trouble installing `pact` via this repository.

This repository helps you install the [Pact](https://github.com/kadena-io/pact) smart contract programming language without having to build it from source. You can use this repo in a few ways:

First, you can run `pact` on your machine from this flake. For example:

```console
$ nix run github.com:thomashoneyman/pact-nix
pact>

# Or, use a particular version of Pact
$ nix run github.com:thomashoneyman/pact-nix#pact-4_1_1
```

Second, legacy commands like `nix-build` and `nix-env` are supported. For example, you can install a particular version of Pact to your environment:

```console
$ git clone https://github.com/thomashoneyman/pact-nix && cd pact-nix
$ nix-env -f default.nix -iA pact
```

Third, you can import this Nix code into your own to make the various Pact binaries available. The rest of this README covers this case.

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

Once you have `pact-nix` from this repository you can refer to specific Pact binaries.

For example, you can write an overlay to put a particular Pact version into your `pkgs`. Here is an example in a Nix flake:

```nix
{
  outputs = { nixpkgs, pact-nix, ... }:
    let
      pactOverlay = _: _: { pact = pact-nix.pact; };
      pkgs = import nixpkgs { overlays = [ pactOverlay ]; };
    in
      # Now `pact` is available in your `pkgs`.
      { devShell = pkgs.mkShell { buildInputs = [ pkgs.pact ]; };
      };
}
```

The `pact` binary tracks the latest available version, but you can also refer to a specific version of Pact. Here's an example in a non-Flakes file:

```nix
{ pkgs }:

let
  pact-nix = { ... }; # See installation instructions above.

in
pkgs.mkShell
  { buildInputs = [ pact-nix.pact-4_2_1 ];
  }
```
