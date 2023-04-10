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
    # 6.2 release did not have a build script capable of baking in font features.
    firacode-src.url =
      "github:tonsky/firacode/20f11a21e0b7284e0cb40c594d2fa6091d775256";
    firacode-src.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, mach-nix, pypi, sfnt2woff-zopfli-src, firacode-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonEnv = mach-nix.lib.${system}.mkPython rec {
          python = "python39";
          # Bump pycairo version to nixpkgs-22.11.
          requirements = ''
            pillow==5.4.1
            idna==2.8
            requests==2.21.0
            urllib3==1.24.1
            pycairo==1.21.0
            gftools==0.7.4
            fontmake==2.4.0
            fontbakery==0.8.0

            opentype-feature-freezer==1.32.2
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
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "fira-code-custom";
          version = "6.2";

          src = firacode-src;
          buildInputs = with pkgs; [
            ttfautohint
            woff2
            pythonEnv
            sfnt2woff-zopfli
          ];
          buildPhase = ''
            ln -s ${pkgs.bash}/bin/bash /bin/bash
            ln -s ${pkgs.coreutils}/bin/* /bin

            script/build.sh --features "ss02,ss08" --family-name "Fira Code Custom"

            echo "Baking in alternate at-symbol..."
            find distr -type d -name 'Fira Code Custom' -execdir bash -c 'for font in "$1"/*; do
              pyftfeatfreeze -f "ss05" "$font" "$font"; done' none {} \;
          '';
          installPhase = ''
            mkdir -p $out/share/fonts
            cp -r distr/* $out/share/fonts/
          '';
        };

        formatter = pkgs.nixpkgs-fmt;
      });
}
