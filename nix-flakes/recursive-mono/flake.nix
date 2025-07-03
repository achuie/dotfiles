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
      forAllSystems = f:
        nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
          f (import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          }));
    in
    {
      overlay = final: prev:
        let
          italic-config = builtins.toFile "italic.yaml" ''
            Family Name: Custom

            Fonts:
              Regular:
                MONO: 1
                CASL: 0
                wght: 360
                slnt: 0
                CRSV: 0
              Italic:
                MONO: 1
                CASL: 0
                wght: 360
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
                CASL: 0
                wght: 360
                slnt: 0
                CRSV: 0
              Italic:
                MONO: 1
                CASL: 0
                wght: 360
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
              - ss03
              - ss05
          '';
          pythonEnv = final.python3.withPackages (ps:
            with ps;
            [ skia-pathops pyyaml ] ++ [
              (final.python3.pkgs.buildPythonPackage rec {
                pname = "font-v";
                version = "2.1.0";
                src = final.python3.pkgs.fetchPypi {
                  inherit pname version;
                  sha256 = "1l5xcs2f6jh1p3zl8knfixyh5qgkchipjb2h6d3g1pd70h3clzaw";
                };
                propagatedBuildInputs = with final.python3.pkgs; [ fonttools gitpython ];
              })
              (final.python3.pkgs.buildPythonPackage rec {
                pname = "ttfautohint-py";
                version = "0.5.1";
                src = final.python3.pkgs.fetchPypi {
                  inherit pname version;
                  sha256 = "1yllzbsq18y3l5sq7z7fa78klp93ngw6iszzs8zap6bk8ghj9qym";
                };
                buildInputs = [ final.python3.pkgs.setuptools-scm ];
              })
              (final.python3.pkgs.buildPythonPackage rec {
                pname = "opentype-feature-freezer";
                version = "1.32.2";
                src = final.python3.pkgs.fetchPypi {
                  inherit pname version;
                  sha256 = "0wxmqbf6lrkkjsvg2ck5v304fbyq31b2nvs7ala2ykpfpwh37jfd";
                };
                propagatedBuildInputs = [ final.python3.pkgs.fonttools ];
              })
            ]);
        in
        {
          rec-mono-custom = final.stdenv.mkDerivation {
            pname = "recursive-mono-custom";
            version = "1.085";

            src = recMono;

            buildPhase = ''
              export LD_LIBRARY_PATH="${final.ttfautohint}/lib:LD_LIBRARY_PATH"

              mkdir nix-output

              ${pythonEnv}/bin/python \
                scripts/instantiate-code-fonts.py ${italic-config} 
              cp fonts/RecMonoCustom/*Italic* nix-output

              ${pythonEnv}/bin/python \
                scripts/instantiate-code-fonts.py ${regular-bold-config}
              cp fonts/RecMonoCustom/*Regular* fonts/RecMonoCustom/*Bold-* nix-output
            '';

            installPhase = ''
              mkdir -p $out/share/fonts/truetype
              cp ./nix-output/* $out/share/fonts/truetype
            '';
          };
        };

      packages = forAllSystems (pkgs: { default = pkgs.rec-mono-custom; });

      formatter = forAllSystems (pkgs: pkgs.nixpkgs-fmt);
    };
}
