{
  lib,
  pkgs,
  ...
}:
{
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.hello
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPY5PE/6LzFDNE6omKBo+nfl/XWAqeq3GcF/3Er1kxMY"
  ];

  system.stateVersion = "25.11";
}
