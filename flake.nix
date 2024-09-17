{
  description = "Nix Flake for miaTime R package";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        miaTime = pkgs.rPackages.buildRPackage {
          name = "miaTime";
          src = self;
          propagatedBuildInputs = builtins.attrValues {
            inherit (pkgs.rPackages)
              dplyr
              mia
              S4Vectors
              SummarizedExperiment
              SingleCellExperiment
              vegan
              scater
              ;
          };
        };
      in
      {
        packages.default = miaTime;
        devShells.default = pkgs.mkShell {
          buildInputs = [ miaTime ];
          inputsFrom = pkgs.lib.singleton miaTime;
        };
      }
    );
}
