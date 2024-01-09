{
  description = "A developer shell for working on elm-random-quote-machine.";

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
          name = "elm-random-quote-machine";

          packages = with pkgs.elmPackages; [
            elm
            elm-format
            elm-optimize-level-2
            elm-review
            pkgs.caddy
            pkgs.dart-sass
            pkgs.shellcheck
            pkgs.terser
          ];

          shellHook =
            ''
            export project="$PWD"
            export build="$project/.build"
            export PATH="$project/bin:$PATH"
            '';
        };
      }
    );
}
