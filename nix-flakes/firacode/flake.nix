{
  description = "Customized Fira Code";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.11";

    mach-nix = {
      url = "github:davhau/mach-nix";
      inputs.pypi-deps-db.follows = "pypi";
    };
    pypi = {
      url = "github:davhau/pypi-deps-db";
      flake = false;
    };

    sfnt2woff-zopfli-src = {
      url = "github:bramstein/sfnt2woff-zopfli";
      flake = false;
    };
    # 6.2 release did not have a build script capable of baking in font features.
    firacode = {
      url = "github:tonsky/firacode/20f11a21e0b7284e0cb40c594d2fa6091d775256";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, mach-nix, pypi, sfnt2woff-zopfli-src, firacode }:
    let
      forAllSystems = f: nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
        f {
          pkgs = nixpkgs.legacyPackages.${system};
          machNix = mach-nix.lib.${system};
        });
    in
    {
      packages = forAllSystems (pset: with pset;
        let
          pythonEnv = machNix.mkPython rec {
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
          default = pkgs.stdenv.mkDerivation {
            pname = "fira-code-custom";
            version = "6.2";

            src = firacode;
            buildInputs = with pkgs; [
              ttfautohint
              woff2
              pythonEnv
              sfnt2woff-zopfli
            ];
            buildPhase = ''
              patchShebangs --build script/*.sh

              echo "Removing specific ligatures from glyphs file..."
              ${pythonEnv}/bin/python ${self}/remove_specific_ligatures.py "bar_bar_bar_greater" \
                "less_bar_bar_bar" "bar_bar_greater" "less_bar_bar" "bar_greater" "less_bar" \
                "less_exclam_hyphen_hyphen" "asciitilde_asciitilde_greater" "exclam_equal_equal" \
                "less_asciitilde_asciitilde" "plus_plus_plus" "asciitilde_asciitilde" \
                "asciitilde_at" "asciitilde_greater" "asciitilde_hyphen" "bar_braceright" \
                "bar_bracketright" "braceleft_bar" "bracketleft_bar" "bracketright_numbersign" \
                "dollar_greater" "exclam_equal" "greater_equal" "hyphen_asciitilde" \
                "less_asciitilde" "less_dollar" "less_equal" "numbersign_braceleft" \
                "numbersign_bracketleft" "numbersign_parenleft" "plus_plus" "slash_backslash" \
                "backslash_slash" "equal_arrows" "hyphen_arrows" "underscores"

              echo "Running build script..."
              script/build.sh --features "ss08" --family-name "Fira Code Custom"

              echo "Baking in alternate at-symbol..."
              find distr -type d -name 'Fira Code Custom' -execdir bash -c 'for font in "$1"/*; do
                pyftfeatfreeze -f "ss05" "$font" "$font"; done' none {} \;
            '';
            installPhase = ''
              mkdir -p $out/share/fonts
              cp -r distr/* $out/share/fonts/
            '';
          };
        });

      formatter = forAllSystems (pset: pset.pkgs.nixpkgs-fmt);
    };
}
