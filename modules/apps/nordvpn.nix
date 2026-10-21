{
  flake.aspects.base.nixos = { config, lib, ... }: {
    services.nordvpn.enable = true;
    users.users.${config.var.username}.extraGroups = [ "nordvpn" ];

    systemd.sockets.nordvpnd.enable = false;
    systemd.services.nordvpnd.serviceConfig.Requires = lib.mkForce null;
  };
}
