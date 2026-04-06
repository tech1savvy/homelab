{
  description = "Remotely Managed, and Declarative NixOS Homelab Server";

  inputs.deploy-rs.url = "github:serokell/deploy-rs";
  inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      deploy-rs,
      sops-nix,
    }:
    {
      nixosConfigurations = {
        lab = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/aws.nix
            ./configuration.nix
            ./modules/k3s

            sops-nix.nixosModules.sops
            ./modules/sops.nix
          ];
        };
      };

      deploy.nodes = {
        lab = {
          hostname = "lab";
          profiles.system = {
            user = "root";
            sshUser = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.lab;
          };

          remoteBuild = false;
        };
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
