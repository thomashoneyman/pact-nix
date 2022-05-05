{ stdenv, lib, fetchzip }:

let
  mkPactDerivation = version: src:
    stdenv.mkDerivation {
      inherit version src;
      pname = "pact";
      installPhase = ''
        mkdir -p $out/bin
        PACT="$out/bin/pact"
        install -D -m555 -T pact $PACT
      '';
      meta = {
        description = "Pact smart contract language";
        homepage = "https://github.com/kadena-io/pact";
        license = lib.licenses.bsd3;
      };
    };

  # When a new Pact version comes out, this must be updated.
  pact-latest = "pact-4_3";

  pact-versions = {
    # Versions follow the output of `pact --version`. Pact versions are somewhat
    # inconsistent: they are not always MAJOR.MINOR.PATCH.
    pact-4_3 = let
      version = "4.3";
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
          sha256 = "";
        };
    in mkPactDerivation version src;

    pact-4_2_1 = let
      version = "4.2.1";
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
          sha256 = "";
        };
    in mkPactDerivation version src;

    pact-4_2_0 = let
      version = "4.2.0";
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-applications.8.10.7.macOS-latest.zip";
          sha256 = "sha256-5nX5Xjr9NSuhBQZcurM74+QJ80IIekGiY7+lmF2rDZ0=";
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-applications.8.10.7-ubuntu-20.04.zip";
          sha256 = "";
        };
    in mkPactDerivation version src;

    pact-4_1_1 = let
      version = "4.1.1";
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-applications.8.10.7.macOS-latest.zip";
          sha256 = "sha256-mBNjWJ43tHgoJHYvdrBRJ7uG0RYoHArZqcAHRQVlxDM=";
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-applications.8.10.7-ubuntu-20.04.zip";
          sha256 = "";
        };
    in mkPactDerivation version src;

    pact-4_1 = let
      version = "4.1";
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
          sha256 = "";
        };
    in mkPactDerivation version src;

    pact-4_0_1 = let
      version = "4.0.1";
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
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux-20.04.zip";
          sha256 = "";
          stripRoot = false;
        };
    in mkPactDerivation version src;

    pact-3_7_0 = let
      version = "3.7.0";
      src = if stdenv.isDarwin then
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-osx.zip";
          sha256 = "sha256-jvk6HkCZln/3IyuwU21AAuBfYBGuDgbER+2MuuBX83s=";
          stripRoot = false;
        }
      else
        fetchzip {
          url =
            "https://github.com/kadena-io/pact/releases/download/v${version}/pact-${version}-linux.zip";
          sha256 = "";
          stripRoot = false;
        };
    in mkPactDerivation version src;

    pact-3_5_1 = let
      version = "3.5.1";
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
          sha256 = "";
          stripRoot = false;
        };
    in mkPactDerivation version src;

    pact-3_5_0 = let
      version = "3.5.0";
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
          sha256 = "";
          stripRoot = false;
        };
    in mkPactDerivation version src;

    pact-3_4_0 = let
      version = "3.4.0";
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
          sha256 = "";
          stripRoot = false;
        };
    in mkPactDerivation version src;

    pact-3_3_1 = let
      version = "3.3.1";
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
          sha256 = "";
          stripRoot = false;
        };
    in mkPactDerivation version src;

    pact-3_3_0 = let
      version = "3.3.0";
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
          sha256 = "";
          stripRoot = false;
        };
    in mkPactDerivation version src;

    pact-3_1_0 = let
      version = "3.1.0";
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
          sha256 = "";
          stripRoot = false;
        };
    in mkPactDerivation version src;

    pact-3_0_1 = let
      version = "3.0.1";
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
          sha256 = "";
          stripRoot = false;
        };
    in mkPactDerivation version src;

    pact-3_0 = let
      version = "3.0";
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
          sha256 = "";
          stripRoot = false;
        };
    in mkPactDerivation version src;
  };

in pact-versions // { pact = pact-versions.${pact-latest}; }
