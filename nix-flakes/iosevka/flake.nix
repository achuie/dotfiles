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
              spacing = "fontconfig-mono";
              serifs = "sans";
              noCvSs = true;
              export-glyph-names = false;
              variants = {
                design = {
                  capital-q = "detached-bend-tailed";
                  g = "double-storey";
                  l = "tailed-serifed";
                  one = "base";
                  number-sign = "slanted";
                  at = "fourfold-tall";
                };
                italic = {
                  capital-q = "open-swash";
                  g = "single-storey-flat-hook-serifless";
                  y = "cursive-flat-hook-serifless";
                  at = "fourfold-solid-inner-tall";
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
              ligations = {
                inherits = "default-calt";
                enables = [ "hash-hash" ];
                disables = [
                  "arrow-l" "arrow-r"
                  "counter-arrow-l" "counter-arrow-r"
                  "eqeqeq" "eqeq"
                  "lteq" "eqlt" "gteq"
                  "exeqeqeq" "exeqeq" "eqexeq" "eqexeq-dl" "exeq"
                  "tildeeq" "eqslasheq" "slasheq"
                  "plus-plus" "plus-plus-plus"
                  "llggeq"
                  "html-comment"
                  "colon-greater-as-colon-arrow"
                  "brace-bar" "brack-bar"
                  "underscore-underscore" "underscore-underscore-underscore"
                  "tilde-tilde" "tilde-tilde-tilde"
                  "minus-minus" "minus-minus-minus"
                ];
              };
            };
            set = "custom";
          };
        });

      formatter = forAllSystems (pkgs: pkgs.nixpkgs-fmt);
    };
}
