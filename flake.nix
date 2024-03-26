{
  description = "LaTeX Document Demo";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib;
    eachSystem allSystems (system:
      let
        pkgs = import nixpkgs { system = system; };
        tex = pkgs.texliveBasic.withPackages (ps: with ps; [ minifp lettrine ]);
        compile = pkgs.writeShellScriptBin "compile" ''
          ${tex}/bin/pdflatex $1 -o $(echo $1 | sed "s/.tex/.pdf/")
        '';
      in { devShells.default = pkgs.mkShell { packages = [ tex compile ]; }; });
}
