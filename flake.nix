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
    
    in {
      
        #devShells.${system}.default = import ./shell.nix { inherit pkgs; };
        packages.${system}.default = pkgs.writeShellApplication {
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
      };
    };
}
