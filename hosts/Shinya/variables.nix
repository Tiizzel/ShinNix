{ config, ... }: {
  var = {
    # Primary user account name
    username = "tiizzel";

    # Primary user's real or display name
    name = "Tiizzel";

    # Git user details
    gitUsername = "Tiizzel";
    gitEmail = "adamdominik1996@gmail.com";

    # System hostname
    hostname = "Shinya";

    # System pretty hostname (systemd / UI)
    prettyHostname = "Shin'ya";

    # System timezone
    timezone = "Europe/Berlin";

    # System keyboard layout
    keyboardLayout = "de";

    # Primary GPU driver profile: "amd" | "nvidia" | "intel" | "vm" | "generic"
    gpu = "amd";

    # Linux kernel variant: "cachyos" | "cachyos-lto" | "cachyos-bore" | "zen" | "latest" | "default"
    kernel = "cachyos";

    # Bootloader: "grub" | "systemd-boot"
    bootloader = "grub";

    # Enable SOPS encrypted secrets management
    enableSops = true;
  };
}
