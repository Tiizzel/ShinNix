{ inputs, ... }: {
  flake.aspects.base.nixos = { pkgs, ... }: {
    environment.systemPackages = with inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}; [
      google-antigravity-no-fhs
      google-antigravity-ide-no-fhs
      google-antigravity-cli
      pkgs.nixfmt
    ];
  };
}
