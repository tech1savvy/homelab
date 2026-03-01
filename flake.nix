{
  description = "Remotely Managed, and Declarative NixOS Homelab Server";

  inputs.deploy-rs.url = "github:serokell/deploy-rs";

  outputs =
    {
      self,
      nixpkgs,
      deploy-rs,
    }:
    {
      nixosConfigurations = {
        lab = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/aws.nix
            ./configuration.nix
            ./modules/k3s
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
