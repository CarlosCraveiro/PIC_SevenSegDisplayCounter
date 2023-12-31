{
  description = "PIC - Seven Segment Display Counter Project";
  inputs = { 
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; 
    carlospkgs.url = "github:CarlosCraveiro/nixpkgs/master";
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
        counterpic = with import nixpkgs { system = "x86_64-linux"; };  stdenv.mkDerivation {
            name = "counterpic";
            src = self;
            
            nativeBuildInputs = with pkgs; [
                sdcc
                gnumake
                gputils
                
            ];
            buildPhase = ''
                make all
            '';

            installPhase = ''
                mkdir -p $out
                mkdir -p $out/simu
                mkdir -p $out/bin
                cp simu/circuit.simu $out/simu
                cp main.hex $out
            ''; 
        };
    in {
      
        devShells.${system}.default = import ./shell.nix { inherit pkgs; };
        packages.${system} = { 
            default = pkgs.symlinkJoin {
            name = "simulation";
            paths = with pkgs; [ counterpic simulide ];
            postBuild = ''
                sed -i "s|circuit\.hex|$out/main.hex|g" $out/simu/circuit.simu
                echo "#!/bin/sh" > $out/bin/simulation
                echo "$out/bin/simulide $out/simu/circuit.simu" >> $out/bin/simulation
                chmod +x $out/bin/simulation
            '';
        };
};
    };
}
