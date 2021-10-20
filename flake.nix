{
  description = "An awsglue local development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in with pkgs; {

      packages."${system}" = {

        awsglue = callPackage ./awsglue {
          jre = jre8;
          python = python37.withPackages (ps: [ ps.numpy ]);
        };

        glue-notebook = callPackage ./glue-notebook.nix {
          inherit (self.packages."${system}") awsglue;
          python = python37.withPackages (ps: with ps; [ ipykernel numpy pandas ]);
        };

      };

    };
}
