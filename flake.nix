{
  description = "A developer shell for working on the Random Quote Machine tutorial.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          name = "elm-random-quote-machine-tutorial";

          packages = [
            pkgs.mdbook
          ];

          shellHook =
            ''
            export project="$PWD"
            export build="$project/book"
            export PATH="$project/bin:$PATH"
            '';
        };
      }
    );
}
