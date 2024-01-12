# Nix

I'll be using [Nix](https://nixos.org/) to provide a development environment with all the tools required for the project.

## Install

If you don't have Nix installed and you want to follow along then please [install Nix](https://nixos.org/download). If it helps, I run Linux and use the single-user installation option.

Since I'll be using [Nix flakes](https://zero-to-nix.com/concepts/flakes), you will also need to add a line to your `nix.conf` to use the feature without having to pass extra command-line arguments to your Nix commands.

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

## `flake.nix`

In [the project directory](/setup/index.md#the-project-directory), I add a `flake.nix` with the following contents:

```nix
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
```

To enter the developer shell I type `nix develop` while in the project directory.


### `packages`

When I enter the developer shell I will have access to `elm`, `elm-format`, `caddy`, etc. This is due to the following lines:

```nix
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
```

To find out what packages are available you can use [NixOS Search](https://search.nixos.org/packages).

### `shellHook`

When I enter the developer shell the environment variables `project` and `build` will be set and the `"$project/bin"` directory will be on your `PATH`. This is due to the following lines:

```nix
shellHook =
  ''
  export project="$PWD"
  export build="$project/.build"
  export PATH="$project/bin:$PATH"
  '';
```

The environment variables should have the following values:

```bash
$ echo "$project"
/path/to/elm/projects/elm-random-quote-machine

$ echo "$build"
/path/to/elm/projects/elm-random-quote-machine/.build

$ echo "$PATH"
/path/to/elm/projects/elm-random-quote-machine/bin:...
```

## `flake.lock`

When you enter the developer shell for the first time, a `flake.lock` file will be generated. All flake inputs are pinned to specific revisions in that [lockfile](https://zero-to-nix.com/concepts/flakes#lockfile). It ensures that Nix flakes have purely deterministic outputs.

## Learn more Nix

Nix can do so much more but this is not the guide for it. If this little taste of Nix has got you intrigued then I will recommend that you read the following resources:

- [Zero to Nix](https://zero-to-nix.com/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [Nix Reference Manual](https://nixos.org/manual/nix/stable/)

**P.S.** *It takes a while to grok Nix. The key for me was understanding how derivations work ([1](https://zero-to-nix.com/concepts/derivations), [2](https://nixos.org/manual/nix/stable/language/derivations), [3](https://nixos.org/guides/nix-pills/our-first-derivation)) since everything is built around that concept.*
