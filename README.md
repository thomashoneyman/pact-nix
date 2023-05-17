# Pact Nix

[![CI](https://github.com/thomashoneyman/pact-nix/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/thomashoneyman/pact-nix/actions/workflows/ci.yml)

> **WARNING**: This repo is unstable and experimental. Please file an issue if you have trouble installing `pact` or `kda` via this repository.

This repository helps you install the [Pact](https://github.com/kadena-io/pact) smart contract programming language and the [KDA Tool](https://github.com/kadena-io/kda-tool) CLI interface without having to build them from source. You can use this repo in a few ways.

First, you can run `pact` or `kda` on your machine from this flake or install it temporarily in your shell. For example:

```console
# Run the latest version of Pact
$ nix run github:thomashoneyman/pact-nix#pact
pact>

# Run the latest version of KDA tool
$ nix run github:thomashoneyman/pact-nix#kda-tool
Missing: COMMAND

# Or, use a particular version
$ nix run github:thomashoneyman/pact-nix#pact-4_1_1
$ nix run github:thomashoneyman/pact-nix#kda-tool-1_1

# Or, get the executables in your shell temporarily
$ nix develop github:thomashoneyman/pact-nix

$ pact --version
pact version 4.4

$ kda keygen plain
public: 7ac96c11aa771b528a24203c1c57bffc3343fc4c820ef0ae575804149ca6cced
secret: 7269210e1f22be1d00a49da5236c9991969538a18fa359ec3c2908af874cd857
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
      pactOverlay = _: _: { pact = pact-nix.pact; kda-tool = pact-nix.kda-tool; };
      pkgs = import nixpkgs { overlays = [ pactOverlay ]; };
    in
      # Now `pact` is available in your `pkgs`.
      { devShell = pkgs.mkShell { buildInputs = [ pkgs.pact pkgs.kda-tool ]; };
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
