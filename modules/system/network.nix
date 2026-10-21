{
  flake.aspects.base.nixos = { config, lib, ... }: {
    networking.hostName = config.var.hostname;
    networking.networkmanager.enable = true;
    environment.etc."machine-info".text = lib.mkIf (config.var.prettyHostname != "") ''
      PRETTY_HOSTNAME="${config.var.prettyHostname}"
    '';
  };
}
