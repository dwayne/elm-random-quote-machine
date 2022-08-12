{
  pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/a620cb32fefe5f833cc75e215900a5167a644e50.tar.gz") {}
}:

pkgs.mkShell {
  buildInputs = [
    pkgs.caddy
    pkgs.elmPackages.elm
  ];
}
