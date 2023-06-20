{
  description = "Customized Iosevka";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      forAllSystems = f:
        nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs:
        {
          default = pkgs.iosevka.override {
            privateBuildPlan = {
              family = "Iosevka Custom";
              spacing = "term";
              serifs = "sans";
              no-cv-ss = true;
              export-glyph-names = false;
              variants = {
                design = {
                  capital-q = "straight";
                  g = "double-storey";
                  l = "tailed-serifed";
                  one = "base";
                  number-sign = "slanted";
                  at = "fourfold-tall";
                };
                italic = {
                  capital-q = "open-swash";
                  g = "single-storey-flat-hook-serifless";
                  y = "cursive-flat-hook";
                };
              };
              slopes = {
                upright = {
                  angle = 0;
                  shape = "upright";
                  menu = "upright";
                  css = "normal";
                };
                italic = {
                  angle = 9.4;
                  shape = "italic";
                  menu = "italic";
                  css = "italic";
                };
              };
            };
            set = "custom";
          };
        });

      formatter = forAllSystems (pkgs: pkgs.nixpkgs-fmt);
    };
}
