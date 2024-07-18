{
  description = "WEB tools";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    rec {
      packages.${system}.default = pkgs.symlinkJoin {
        name = "web-tools";
        paths = [
          (import ./bin/serve.nix {
            inherit pkgs nixpkgs;
            name = ":serve";
          })
        ];
      };

      devShells.x86_64-linux.default = pkgs.mkShell { buildInputs = [ packages.${system}.default ]; };
    };
}
