{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    recMono = {
      url = "github:arrowtype/recursive-code-config";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, recMono }:
    let
      supportedSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
      pythonEnv = forAllSystems (system:
        pkgs.${system}.python3.withPackages (ps:
          with ps;
          [ skia-pathops pyyaml ] ++ [
            (pkgs.${system}.python3.pkgs.buildPythonPackage rec {
              pname = "font-v";
              version = "2.1.0";
              src = pkgs.${system}.python3.pkgs.fetchPypi {
                inherit pname;
                inherit version;
                sha256 = "1l5xcs2f6jh1p3zl8knfixyh5qgkchipjb2h6d3g1pd70h3clzaw";
              };
              propagatedBuildInputs = with pkgs.${system}.python3.pkgs; [
                fonttools
                gitpython
              ];
            })
            (pkgs.${system}.python3.pkgs.buildPythonPackage rec {
              pname = "ttfautohint-py";
              version = "0.5.1";
              src = pkgs.${system}.python3.pkgs.fetchPypi {
                inherit pname;
                inherit version;
                sha256 = "1yllzbsq18y3l5sq7z7fa78klp93ngw6iszzs8zap6bk8ghj9qym";
              };
              buildInputs = [ pkgs.${system}.python3.pkgs.setuptools-scm ];
            })
            (pkgs.${system}.python3.pkgs.buildPythonPackage rec {
              pname = "opentype-feature-freezer";
              version = "1.32.2";
              src = pkgs.${system}.python3.pkgs.fetchPypi {
                inherit pname;
                inherit version;
                sha256 = "0wxmqbf6lrkkjsvg2ck5v304fbyq31b2nvs7ala2ykpfpwh37jfd";
              };
              propagatedBuildInputs = [ pkgs.${system}.python3.pkgs.fonttools ];
            })
          ]));

      italic-config = builtins.toFile "italic.yaml" ''
        Family Name: Custom

        Fonts:
          Regular:
            MONO: 1
            CASL: 0
            wght: 380
            slnt: 0
            CRSV: 0
          Italic:
            MONO: 1
            CASL: 0
            wght: 380
            slnt: -10
            CRSV: 1
          Bold:
            MONO: 1
            CASL: 0
            wght: 700
            slnt: 0
            CRSV: 0
          Bold Italic:
            MONO: 1
            CASL: 0
            wght: 700
            slnt: -10
            CRSV: 1

        Code Ligatures: False

        Features:
          - ss05
      '';
      regular-bold-config = builtins.toFile "bold.yaml" ''
        Family Name: Custom

        Fonts:
          Regular:
            MONO: 1
            CASL: 0.3
            wght: 380
            slnt: 0
            CRSV: 0
          Italic:
            MONO: 1
            CASL: 0
            wght: 380
            slnt: -10
            CRSV: 1
          Bold:
            MONO: 1
            CASL: 0.3
            wght: 700
            slnt: 0
            CRSV: 0
          Bold Italic:
            MONO: 1
            CASL: 0
            wght: 700
            slnt: -10
            CRSV: 1

        Code Ligatures: False

        Features:
          - ss03
          - ss05
      '';
    in {
      packages = forAllSystems (system: {
        default = pkgs.${system}.stdenv.mkDerivation {
          pname = "recursive-mono-custom";
          version = "1.085";

          src = "${recMono}";

          buildPhase = ''
            export LD_LIBRARY_PATH="${
              pkgs.${system}.ttfautohint
            }/lib:LD_LIBRARY_PATH"

            mkdir nix-output

            ${pythonEnv.${system}}/bin/python \
              scripts/instantiate-code-fonts.py ${italic-config} 
            cp fonts/RecMonoCustom/*Italic* nix-output

            ${pythonEnv.${system}}/bin/python \
              scripts/instantiate-code-fonts.py ${regular-bold-config}
            cp fonts/RecMonoCustom/*Regular* fonts/RecMonoCustom/*Bold-* nix-output
          '';

          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            cp ./nix-output/* $out/share/fonts/truetype
          '';
        };
      });

      formatter = forAllSystems (system: pkgs.${system}.nixfmt);
    };
}
