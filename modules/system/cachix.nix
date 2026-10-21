{ inputs, ... }: {
  flake.aspects.base.nixos =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      nix.settings = {
        substituters = lib.mkAfter [
          "https://cache.nixos.org"
          "https://hyprland.cachix.org"
          "https://nix-community.cachix.org"
          "https://noctalia.cachix.org"
          "https://nyx-cache.chaotic.cx"
          "https://chaotic-nyx.cachix.org"
        ];
        trusted-public-keys = lib.mkAfter [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="
          "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n8AEPssxErmyyBmIlbLpHURSTzTQ0="
        ];
      };
    };
}
