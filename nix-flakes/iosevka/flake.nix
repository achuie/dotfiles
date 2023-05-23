{
  description = "Customized Iosevka";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    npmlock2nix.url = "github:nix-community/npmlock2nix";
    npmlock2nix.flake = false;

    iosevka.url = "github:be5invis/Iosevka/v23.0.0";
    iosevka.flake = false;
  };

  outputs = { self, nixpkgs, npmlock2nix, iosevka }:
    let
      forAllSystems = f:
        nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
          f (import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          })
        );
    in
    {
      overlay = final: prev:
        let
          npml2n = (final.callPackage npmlock2nix { }).v2;
          customBuildConf = final.writeText "private-build-plans.toml" ''
            [buildPlans.iosevka-custom]
            family = "Iosevka Custom"
            spacing = "normal"
            serifs = "sans"
            no-cv-ss = true
            export-glyph-names = false
            no-ligation = true

            [buildPlans.iosevka-custom.variants.design]
            capital-q = "straight"
            g = "double-storey"
            l = "tailed-serifed"
            one = "base"
            number-sign = "slanted"
            at = "fourfold-tall"

            [buildPlans.iosevka-custom.variants.italic]
            capital-q = "open-swash"
            g = "single-storey-flat-hook-serifless"
            y = "cursive-flat-hook"

            [buildPlans.iosevka-custom.slopes.upright]
            angle = 0
            shape = "upright"
            menu = "upright"
            css = "normal"

            [buildPlans.iosevka-custom.slopes.italic]
            angle = 9.4
            shape = "italic"
            menu = "italic"
            css = "italic"
          '';
        in
        {
          iosevka-custom = npml2n.build {
            nodejs = final.nodejs;
            src = iosevka;

            buildInputs = [ final.ttfautohint ];
            buildCommands = [
              "cp ${customBuildConf} ./private-build-plans.toml"
              "npm run build -- ttf::iosevka-custom"
            ];

            installPhase = ''
              mkdir -p $out/share/fonts/truetype
              cp -r dist/iosevka-custom $out/share/fonts/truetype
            '';
          };
        };

      packages = forAllSystems (pkgs: { default = pkgs.iosevka-custom; });

      formatter = forAllSystems (pkgs: pkgs.nixpkgs-fmt);
    };
}
