{ stdenv, lib, fetchzip, gmp, zlib, z3, ncurses5, ncurses6 }:

let
  dynamic-linker = stdenv.cc.bintools.dynamicLinker;

  patchelf = libPath:
    if stdenv.isDarwin then
      ""
    else ''
      chmod u+w $PACT
      patchelf --interpreter ${dynamic-linker} --set-rpath ${libPath} $PACT
      chmod u-w $PACT
    '';

  mkPactDerivation = { version, ncurses, src }:
    stdenv.mkDerivation rec {
      inherit version src;
      pname = "pact";
      buildInputs = [ zlib z3 gmp ncurses ];
      libPath = lib.makeLibraryPath buildInputs;
      dontStrip = true;
      installPhase = ''
        mkdir -p $out/bin
        PACT="$out/bin/pact"
        install -D -m555 -T pact $PACT
        ${patchelf libPath}
      '';
      meta = {
        description = "Pact smart contract language";
        homepage = "https://github.com/kadena-io/pact";
        license = lib.licenses.bsd3;
      };
    };

  # When a new Pact version comes out, this must be updated.
  pact-latest = "pact-4_3_1";

  pact-versions = {
    # Versions follow the output of `pact --version`. Pact versions are somewhat
    # inconsistent: they are not always MAJOR.MINOR.PATCH.
    pact-4_3_1 = mkPactDerivation rec {
      version = "4.3.1";
      ncurses = ncurses6;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
          sha256 = "sha256-mgZwSHxJPVnQbWLK7/68eZeU/pIxMfVWYH7WNg69rqE=";
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-20.04.zip";
          sha256 = "sha256-2qfJMvqfZ5na69VcGVmjcFLRNpsJhh3pemIiFQP4ymg=";
        };
    };

    pact-4_3 = mkPactDerivation rec {
      version = "4.3";
      ncurses = ncurses6;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
          sha256 = "sha256-7MFb3eyZcrX9RSCYQyQ61brI9deAOuV1dz1+AhLHcVI=";
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-20.04.zip";
          sha256 = "sha256-EQNK9MK3AD3mXMNHu04pVvQyALb3HL4ey+csFCY/mdQ=";
        };
    };

    pact-4_2_1 = mkPactDerivation rec {
      version = "4.2.1";
      ncurses = ncurses6;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
          sha256 = "sha256-B8krKnje2GeYAjNwJwrFeMt9Lx/28b137hxsfBI251g=";
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-20.04.zip";
          sha256 = "sha256-GmVvsMBamZ/70incmVKzTzmgXLNuOWco/z+vDGiFgTQ=";
        };
    };

    pact-4_2_0 = mkPactDerivation rec {
      version = "4.2.0";
      ncurses = ncurses6;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-applications.8.10.7.macOS-latest.zip";
          sha256 = "sha256-5nX5Xjr9NSuhBQZcurM74+QJ80IIekGiY7+lmF2rDZ0=";
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-applications.8.10.7.ubuntu-20.04.zip";
          sha256 = "sha256-VXx6WDaqlSfmLS2bJEBOlN+Oc2K0aQNWpIBdth3vnjc=";
        };
    };

    pact-4_1_1 = mkPactDerivation rec {
      version = "4.1.1";
      ncurses = ncurses6;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-applications.8.10.7.macOS-latest.zip";
          sha256 = "sha256-mBNjWJ43tHgoJHYvdrBRJ7uG0RYoHArZqcAHRQVlxDM=";
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-applications.8.10.7.ubuntu-20.04.zip";
          sha256 = "sha256-sJ0J+UIO5FJXGcXgSkkPctdEIJjbBJ2GlJXu0K8AVbM=";
        };
    };

    pact-4_1 = mkPactDerivation rec {
      version = "4.1";
      ncurses = ncurses6;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
          sha256 = "sha256-ydmP8DN8W+0dOB+r0Z6gcxJcyOnkzR/e1U+t3GcQ/fs=";
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-20.04.zip";
          sha256 = "sha256-R13LUdPTRMSNERDfQNlPx0MubF6aMwdtPAO2NWiOyyo=";
        };
    };

    pact-4_0_1 = mkPactDerivation rec {
      version = "4.0.1";
      ncurses = ncurses5;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
          sha256 = "sha256-u6fciTDgNY7OwS/cGhdOb1URdOqhYqWN3NfdMWiwK/0=";
          stripRoot = false;
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
          sha256 = "sha256-8NXoyaHuz3RiKPTRFLhUavsdRJho6qbNEjSBBb0HI5c=";
          stripRoot = false;
        };
    };

    pact-3_7 = mkPactDerivation rec {
      version = "3.7";
      ncurses = ncurses5;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}.0/pact-${version}.0-osx.zip";
          sha256 = "sha256-jvk6HkCZln/3IyuwU21AAuBfYBGuDgbER+2MuuBX83s=";
          stripRoot = false;
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}.0/pact-${version}.0-linux.zip";
          sha256 = "sha256-tvHj0oJxvbf+lCvU9mRHGjl3nKZRm77U8mELpJbypxs=";
          stripRoot = false;
        };
    };

    pact-3_5_1 = mkPactDerivation rec {
      version = "3.5.1";
      ncurses = ncurses5;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
          sha256 = "sha256-dlTCvjjyuhpTv4Uou53e9COqpKK1TKZ6DwJtK+C9qGo=";
          stripRoot = false;
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
          sha256 = "sha256-F4pyw7eQR2ANeT1E1gi7suHWO3734tyeSUTHWfovHa8=";
          stripRoot = false;
        };
    };

    pact-3_5_0 = mkPactDerivation rec {
      version = "3.5.0";
      ncurses = ncurses5;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
          sha256 = "sha256-JsZc0IH29QsRQAKw09ItUYjYGeAu0potUncKhCq0c7s=";
          stripRoot = false;
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
          sha256 = "sha256-Fjj63WvzK/VLSYdoW6cGKMtmx+YJ5dRvs7O/LKKbWmo=";
          stripRoot = false;
        };
    };

    pact-3_4_0 = mkPactDerivation rec {
      version = "3.4.0";
      ncurses = ncurses5;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
          sha256 = "sha256-5aSg15qsYjeILQkQgqpZlMuNsuCX3wcAA7hhPETdxA8=";
          stripRoot = false;
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
          sha256 = "sha256-P9ALttXzwamfD9PTkixWngJ6uhmQi+0GX8GjFJ+rluw=";
          stripRoot = false;
        };
    };

    pact-3_3_1 = mkPactDerivation rec {
      version = "3.3.1";
      ncurses = ncurses5;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
          sha256 = "sha256-AIzK5F4DIgSmKCHzQ40LGEvViKxfe71/cZG0bsoom14=";
          stripRoot = false;
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
          sha256 = "sha256-lTmeRF910r6FBd4aXSPnjXIIgBGCi1sAlaJslpvOzE0=";
          stripRoot = false;
        };
    };

    pact-3_3_0 = mkPactDerivation rec {
      version = "3.3.0";
      ncurses = ncurses5;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
          sha256 = "sha256-7Usicb7LwMS0pgdSjINZFVRJwvihpuBGscZNqiSSncA=";
          stripRoot = false;
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
          sha256 = "sha256-6t4JR6Mp70fwXYvXele28yEljOU7slSowWjTfJrmyIM=";
          stripRoot = false;
        };
    };

    pact-3_1_0 = mkPactDerivation rec {
      version = "3.1.0";
      ncurses = ncurses5;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
          sha256 = "sha256-SHt+WBbAgoBx9VHJQ7nJYcWzkViZovI2lmsQKZUtTfg=";
          stripRoot = false;
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
          sha256 = "sha256-j+muNtkkRtasYBBplyi/83j9xYve6gvcdQ7FWP3STMQ=";
          stripRoot = false;
        };
    };

    pact-3_0_1 = mkPactDerivation rec {
      version = "3.0.1";
      ncurses = ncurses5;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
          sha256 = "sha256-hCHQyNrS5pMLUDxzbAiEYzStMfQuGTSeYeaLZuH/ZKM=";
          stripRoot = false;
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
          sha256 = "sha256-Vwd/NyqM1KIZivkwD2hOYs1pW/ZHvhlpxkkjgl5bnN4=";
          stripRoot = false;
        };
    };

    pact-3_0 = mkPactDerivation rec {
      version = "3.0";
      ncurses = ncurses5;
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
          sha256 = "sha256-DdCnqXwx/lPed/1LEvzkvafjTxHFz8dYOtV3++FYpxQ=";
          stripRoot = false;
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
          sha256 = "sha256-niuONI+tLPO3S5IW/E3ZhmxUJueiLOzJPxwG8+rI81I=";
          stripRoot = false;
        };
    };

  };

in pact-versions // { pact = pact-versions.${pact-latest}; }
