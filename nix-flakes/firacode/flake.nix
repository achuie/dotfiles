{
  description = "Customized Fira Code";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.11";
    utils.url = "github:numtide/flake-utils";
    firacode-src = {
      url = "github:tonsky/firacode/6.2";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, firacode-src }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonEnv = pkgs.python3.withPackages (ps: [
          (pkgs.python3.pkgs.buildPythonPackage rec {
            pname = "opentype-feature-freezer";
            version = "1.32.2";
            src = pkgs.python3.pkgs.fetchPypi {
              inherit pname;
              inherit version;
              sha256 = "0wxmqbf6lrkkjsvg2ck5v304fbyq31b2nvs7ala2ykpfpwh37jfd";
            };
            propagatedBuildInputs = [ pkgs.python3.pkgs.fonttools ];
          })
      ]);

      in {
        defaultPackage = pkgs.stdenv.mkDerivation {
          pname = "fira-code-custom";
          version = "6.2";

          unpackPhase = "true";
          buildPhase = ''
            ${pythonEnv}/bin/pyftfeatfreeze -f 'ss02,ss05,ss08' -S -U Custom \
              ${pkgs.fira-code}/share/fonts/truetype/FiraCode-VF.ttf \
              FiraCode-VF-Custom.ttf
          '';
          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            cp FiraCode-VF-Custom.ttf $out/share/fonts/truetype
          '';
        };

        formatter = pkgs.nixfmt;
      });
}
