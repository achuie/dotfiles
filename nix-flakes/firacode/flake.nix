{
  description = "Customized Fira Code";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.11";
    flake-utils.url = "github:numtide/flake-utils";

    mach-nix.url = "github:davhau/mach-nix";
    mach-nix.inputs.pypi-deps-db.follows = "pypi";
    pypi.url = "github:davhau/pypi-deps-db";
    pypi.flake = false;

    sfnt2woff-zopfli-src.url = "github:bramstein/sfnt2woff-zopfli";
    sfnt2woff-zopfli-src.flake = false;
    firacode-src.url = "github:tonsky/firacode/6.2";
    firacode-src.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, mach-nix, pypi, sfnt2woff-zopfli-src
    , firacode-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonEnv = mach-nix.lib.${system}.mkPython {
          requirements = ''
            pillow
            idna
            requests
            urllib3
            pycairo
            gftools
            fontmake
            fontbakery
          '';
        };
        sfnt2woff-zopfli = pkgs.stdenv.mkDerivation rec {
          pname = "sfnt2woff-zopfli";
          version = "1.3.1";

          src = sfnt2woff-zopfli-src;
          buildInputs = [ pkgs.zlib ];
          buildPhase = "make";
          installPhase = ''
            mkdir -p $out/bin
            cp sfnt2woff-zopfli woff2sfnt-zopfli $out/bin
          '';
        };
      in {
        defaultPackage = pkgs.stdenv.mkDerivation {
          pname = "fira-code-custom";
          version = "6.2";

          buildInputs = with pkgs; [
            ttfautohint
            woff2
            pythonEnv
            sfnt2woff-zopfli
          ];
          buildPhase = ''
            ls
          '';
          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            cp FiraCode-VF-Custom.ttf $out/share/fonts/truetype
          '';
        };

        formatter = pkgs.nixfmt;
      });
}
