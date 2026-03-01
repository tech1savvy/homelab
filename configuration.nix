{
  lib,
  pkgs,
  ...
}:
{
  services.openssh.enable = true;
  networking = {
    hostName = "lab";
    domain = "tech1savvy.me";
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.hello
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPY5PE/6LzFDNE6omKBo+nfl/XWAqeq3GcF/3Er1kxMY"
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  system.stateVersion = "25.11";
}
