{
  description = "Customized Fira Code";

  inputs = {
    # Use stable nixpkgs for compatibility with mach-nix.
    nixpkgs.url = "github:nixos/nixpkgs/21.11";
    utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mach-nix = {
      url = "github:davhau/mach-nix/3.4.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pypi-deps-db.url = "github:davhau/pypi-deps-db";
    };
  };

  outputs = { self, nixpkgs, utils, mach-nix }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        otfeaturefreezer = mach-nix.lib.${system}.mkPython {
          requirements = "opentype-feature-freezer";
        };
      in {
        defaultPackage = pkgs.stdenv.mkDerivation {
          name = "fira-code-custom";

          buildInputs = [ pkgs.fira-code otfeaturefreezer ];

          unpackPhase = "true";
          installPhase = "true";
          fixupPhase = ''
            mkdir -p $out/share/fonts/truetype
            pyftfeatfreeze -f 'ss05' -S -U Custom \
            ${pkgs.fira-code}/share/fonts/truetype/FiraCode-VF.ttf \
            $out/share/fonts/truetype/FiraCode-VF-Custom.ttf
          '';
        };

        formatter = pkgs.nixfmt;
      });
}
