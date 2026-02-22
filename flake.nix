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
        homelab = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/aws.nix
            ./configuration.nix
          ];
        };
      };

      deploy.nodes = {
        homelab = {
          hostname = "homelab";
          profiles.system = {
            user = "root";
            sshUser = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.homelab;
          };
        };
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
