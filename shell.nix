{ pkgs ? import <nixpkgs> { } }:
let repoRoot = builtins.getEnv "PWD";
in pkgs.mkShell {
  # packages to build the environment
    nativeBuildInputs = with pkgs; [
        sdcc
        gnumake
        gputils
    ];

    buildInputs = with pkgs; [
        simulide
    ];
}
