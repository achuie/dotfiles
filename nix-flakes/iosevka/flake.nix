{
  description = "Customized Iosevka";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    npmlock2nix-git = {
      url = "github:nix-community/npmlock2nix";
      flake = false;
    };
    iosevka = {
      url = "github:be5invis/Iosevka/v15.5.0";
      flake = false;
    };
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, npmlock2nix-git, iosevka }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        npmlock2nix = pkgs.callPackage npmlock2nix-git {};
        writeText = nixpkgs.legacyPackages.${system}.writeText;
        customBuildConf = writeText "private-build-plans.toml" ''
          [buildPlans.iosevka-custom]
          family = "Iosevka Custom"
          spacing = "normal"
          serifs = "sans"
          no-cv-ss = true

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
      in {
        defaultPackage = npmlock2nix.build {
          src = iosevka;

          buildInputs = [ pkgs.ttfautohint ];
          buildCommands = [
            "cp ${customBuildConf} ./private-build-plans.toml"
            "npm run build -- ttf::iosevka-custom"
          ];

          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            cp -r dist/iosevka-custom $out/share/fonts/truetype
          '';
        };

        formatter = pkgs.nixfmt;
      });
}
