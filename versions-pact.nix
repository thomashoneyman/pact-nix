{
  stdenv,
  lib,
  fetchzip,
  gmp,
  zlib,
  z3,
  ncurses5,
  ncurses6,
  openssl,
}: let
  patchelf = libPath:
    if stdenv.isDarwin
    then ""
    else ''
      chmod u+w $PACT
      patchelf --interpreter ${stdenv.cc.bintools.dynamicLinker} --set-rpath ${libPath} $PACT
      chmod u-w $PACT
    '';

  mkPactDerivation = {
    version,
    ncurses,
    extraBuildInputs ? [],
    src,
  }:
    stdenv.mkDerivation rec {
      pname = "pact";
      inherit version src;
      buildInputs = [zlib z3 gmp ncurses] ++ extraBuildInputs;
      libPath = lib.makeLibraryPath buildInputs;
      dontStrip = true;
      installPhase = ''
        PACT="$out/bin/pact"
        install -D -m755 -T pact $PACT
        ${patchelf libPath}
      '';
      meta = {
        description = "Pact smart contract language";
        homepage = "https://github.com/kadena-io/pact";
        license = lib.licenses.bsd3;
      };
    };

  # When a new Pact version comes out, this must be updated.
  pact-latest = "pact-4_11";

  pact-versions = {
    # Versions follow the output of `pact --version`. Pact versions are somewhat
    # inconsistent: they are not always MAJOR.MINOR.PATCH.
    #
    # To update, copy/paste the derivation, update the version number, and set
    # the sha256 fields to empty strings. When you attempt to build the
    # derivation, Nix will tell you the correct sha256 to use.
    pact-4_11 = mkPactDerivation rec {
      version = "4.11";
      ncurses = ncurses6;
      extraBuildInputs = [openssl];
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-22.04.zip";
            sha256 = "sha256-BzIlHepQMgbDrQE3omOmUSBKmaloizXJfF6U9Kkf8Rs=";
            stripRoot = false;
          };
    };

    pact-4_10 = mkPactDerivation rec {
      version = "4.10";
      ncurses = ncurses6;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-22.04.zip";
            sha256 = "sha256-EU4d7Kqi37Zv6Z8baTZBvmvIet17g+cKmg7fS/ql6lg=";
            stripRoot = false;
          };
    };

    pact-4_9 = mkPactDerivation rec {
      version = "4.9";
      ncurses = ncurses6;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-22.04.zip";
            sha256 = "sha256-amBD7QGcEgqStG61sxQmkduXLsPz6DFF8rA7Nd8BHas=";
            stripRoot = false;
          };
    };

    pact-4_8 = mkPactDerivation rec {
      version = "4.8";
      ncurses = ncurses6;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-20.04.zip";
            sha256 = "sha256-zXNv6A/PKwyC5Sl4rdar5Dc4C9dbyFnOb04+jwNDBbI=";
            stripRoot = false;
          };
    };

    pact-4_7_1 = mkPactDerivation rec {
      version = "4.7.1";
      ncurses = ncurses6;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-20.04.zip";
            sha256 = "sha256-LS7HxFikHqZJxhlil7NDkeHhLO62/YNQygHWWYEeNwE=";
            stripRoot = false;
          };
    };

    pact-4_7_0 = mkPactDerivation rec {
      version = "4.7.0";
      ncurses = ncurses6;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-e1bi5nQntQSIF1o3bEKHEVL4AsrPL3NnPKpfCqCIu0c=";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-20.04.zip";
            sha256 = "sha256-Nh3HWAVCyuRnTWSvr8ssnOuQiRyYULF3mSXlX4t/aow=";
            stripRoot = false;
          };
    };

    # Beginning with Pact 4_6_0 the zip file contains more than just the
    # Pact executable, so stripRoot is necessary for fetchzip.
    pact-4_6_0 = mkPactDerivation rec {
      version = "4.6.0";
      ncurses = ncurses6;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-9ZMvvsHccnO4O65oozk6XrEQCrt1rZVLdZrbr7G6FdQ=";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-20.04.zip";
            sha256 = "sha256-2AqVCoxmqKZJeM/7LMjfyITmhVE1dXIN/3eoBjFR+S0=";
            stripRoot = false;
          };
    };

    pact-4_3_1 = mkPactDerivation rec {
      version = "4.3.1";
      ncurses = ncurses6;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-mgZwSHxJPVnQbWLK7/68eZeU/pIxMfVWYH7WNg69rqE=";
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-20.04.zip";
            sha256 = "sha256-2qfJMvqfZ5na69VcGVmjcFLRNpsJhh3pemIiFQP4ymg=";
          };
    };

    pact-4_3 = mkPactDerivation rec {
      version = "4.3";
      ncurses = ncurses6;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-7MFb3eyZcrX9RSCYQyQ61brI9deAOuV1dz1+AhLHcVI=";
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-20.04.zip";
            sha256 = "sha256-EQNK9MK3AD3mXMNHu04pVvQyALb3HL4ey+csFCY/mdQ=";
          };
    };

    pact-4_2_1 = mkPactDerivation rec {
      version = "4.2.1";
      ncurses = ncurses6;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-B8krKnje2GeYAjNwJwrFeMt9Lx/28b137hxsfBI251g=";
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-20.04.zip";
            sha256 = "sha256-GmVvsMBamZ/70incmVKzTzmgXLNuOWco/z+vDGiFgTQ=";
          };
    };

    pact-4_2_0 = mkPactDerivation rec {
      version = "4.2.0";
      ncurses = ncurses6;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-applications.8.10.7.macOS-latest.zip";
            sha256 = "sha256-5nX5Xjr9NSuhBQZcurM74+QJ80IIekGiY7+lmF2rDZ0=";
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-applications.8.10.7.ubuntu-20.04.zip";
            sha256 = "sha256-VXx6WDaqlSfmLS2bJEBOlN+Oc2K0aQNWpIBdth3vnjc=";
          };
    };

    pact-4_1_1 = mkPactDerivation rec {
      version = "4.1.1";
      ncurses = ncurses6;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-applications.8.10.7.macOS-latest.zip";
            sha256 = "sha256-mBNjWJ43tHgoJHYvdrBRJ7uG0RYoHArZqcAHRQVlxDM=";
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-applications.8.10.7.ubuntu-20.04.zip";
            sha256 = "sha256-sJ0J+UIO5FJXGcXgSkkPctdEIJjbBJ2GlJXu0K8AVbM=";
          };
    };

    pact-4_1 = mkPactDerivation rec {
      version = "4.1";
      ncurses = ncurses6;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-ydmP8DN8W+0dOB+r0Z6gcxJcyOnkzR/e1U+t3GcQ/fs=";
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-20.04.zip";
            sha256 = "sha256-R13LUdPTRMSNERDfQNlPx0MubF6aMwdtPAO2NWiOyyo=";
          };
    };

    pact-4_0_1 = mkPactDerivation rec {
      version = "4.0.1";
      ncurses = ncurses5;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-u6fciTDgNY7OwS/cGhdOb1URdOqhYqWN3NfdMWiwK/0=";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
            sha256 = "sha256-8NXoyaHuz3RiKPTRFLhUavsdRJho6qbNEjSBBb0HI5c=";
            stripRoot = false;
          };
    };

    pact-3_7 = mkPactDerivation rec {
      version = "3.7";
      ncurses = ncurses5;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}.0/pact-${version}.0-osx.zip";
            sha256 = "sha256-jvk6HkCZln/3IyuwU21AAuBfYBGuDgbER+2MuuBX83s=";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}.0/pact-${version}.0-linux.zip";
            sha256 = "sha256-tvHj0oJxvbf+lCvU9mRHGjl3nKZRm77U8mELpJbypxs=";
            stripRoot = false;
          };
    };

    pact-3_5_1 = mkPactDerivation rec {
      version = "3.5.1";
      ncurses = ncurses5;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-dlTCvjjyuhpTv4Uou53e9COqpKK1TKZ6DwJtK+C9qGo=";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
            sha256 = "sha256-F4pyw7eQR2ANeT1E1gi7suHWO3734tyeSUTHWfovHa8=";
            stripRoot = false;
          };
    };

    pact-3_5_0 = mkPactDerivation rec {
      version = "3.5.0";
      ncurses = ncurses5;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-JsZc0IH29QsRQAKw09ItUYjYGeAu0potUncKhCq0c7s=";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
            sha256 = "sha256-Fjj63WvzK/VLSYdoW6cGKMtmx+YJ5dRvs7O/LKKbWmo=";
            stripRoot = false;
          };
    };

    pact-3_4_0 = mkPactDerivation rec {
      version = "3.4.0";
      ncurses = ncurses5;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-5aSg15qsYjeILQkQgqpZlMuNsuCX3wcAA7hhPETdxA8=";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
            sha256 = "sha256-P9ALttXzwamfD9PTkixWngJ6uhmQi+0GX8GjFJ+rluw=";
            stripRoot = false;
          };
    };

    pact-3_3_1 = mkPactDerivation rec {
      version = "3.3.1";
      ncurses = ncurses5;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-AIzK5F4DIgSmKCHzQ40LGEvViKxfe71/cZG0bsoom14=";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
            sha256 = "sha256-lTmeRF910r6FBd4aXSPnjXIIgBGCi1sAlaJslpvOzE0=";
            stripRoot = false;
          };
    };

    pact-3_3_0 = mkPactDerivation rec {
      version = "3.3.0";
      ncurses = ncurses5;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-7Usicb7LwMS0pgdSjINZFVRJwvihpuBGscZNqiSSncA=";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
            sha256 = "sha256-6t4JR6Mp70fwXYvXele28yEljOU7slSowWjTfJrmyIM=";
            stripRoot = false;
          };
    };

    pact-3_1_0 = mkPactDerivation rec {
      version = "3.1.0";
      ncurses = ncurses5;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-SHt+WBbAgoBx9VHJQ7nJYcWzkViZovI2lmsQKZUtTfg=";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
            sha256 = "sha256-j+muNtkkRtasYBBplyi/83j9xYve6gvcdQ7FWP3STMQ=";
            stripRoot = false;
          };
    };

    pact-3_0_1 = mkPactDerivation rec {
      version = "3.0.1";
      ncurses = ncurses5;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-hCHQyNrS5pMLUDxzbAiEYzStMfQuGTSeYeaLZuH/ZKM=";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
            sha256 = "sha256-Vwd/NyqM1KIZivkwD2hOYs1pW/ZHvhlpxkkjgl5bnN4=";
            stripRoot = false;
          };
    };

    pact-3_0 = mkPactDerivation rec {
      version = "3.0";
      ncurses = ncurses5;
      src =
        if stdenv.isDarwin
        then
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
            sha256 = "sha256-DdCnqXwx/lPed/1LEvzkvafjTxHFz8dYOtV3++FYpxQ=";
            stripRoot = false;
          }
        else
          fetchzip {
            url = "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
            sha256 = "sha256-niuONI+tLPO3S5IW/E3ZhmxUJueiLOzJPxwG8+rI81I=";
            stripRoot = false;
          };
    };
  };
in
  pact-versions // {pact = pact-versions.${pact-latest};}
