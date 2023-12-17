{
  description = "PIC - Seven Segment Display Counter Project";
  inputs = { 
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; 
    carlospkgs.url = "github:CarlosCraveiro/nixpkgs/master";
    #flake-utils.url = "github:numtide/flake-utils";
    };

  outputs = { self, nixpkgs, carlospkgs, ... }:
    let
        system = "x86_64-linux";
        carlospkgs-overlay = final: prev: {
            simulide = carlospkgs.legacyPackages.${system}.simulide;
        };
    
        sdcc-overlay = final: prev: {
            sdcc = prev.sdcc.override { withGputils = true; };
        };

        pkgs = import nixpkgs {inherit system;
            config.allowUnfree = true;
            overlays = [ sdcc-overlay carlospkgs-overlay ];

        }; 
    in {
      
        #devShells.${system}.default = import ./shell.nix { inherit pkgs; };
        packages.${system}.default = with import nixpkgs { system = "x86_64-linux"; };  stdenv.mkDerivation {
            name = "counterpic";
            src = self;
            
            nativeBuildInputs = with pkgs; [
                sdcc
                gnumake
                gputils
                
            ];

            buildInputs = with pkgs; [
                simulide
            ];

            buildPhase = ''
                make all
                
                echo "#!/bin/sh" > counterpic
                echo "simulide $out/simu/circuito.simu" >> counterpic
                chmod +x counterpic
            '';

            installPhase = ''
                mkdir -p $out
                mkdir -p $out/simu
                mkdir -p $out/bin
                cp simu/circuito.simu $out/simu
                cp counterpic $out/bin
                cp main.hex $out
            '';
            #meta.mainProgram = "counterpic";
        };
      /*  defaultPackage.${system}.default = pkgs.writeShellApplication {
        name = "counterpic";
        runtimeInputs = with pkgs; [ 
            gputils
            sdcc
            simulide
            gnumake
        ];
        text = ''
          make all && simulide simu/circuito.simu
        '';
      };*/
    };
}
