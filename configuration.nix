{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./dev-env.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Set a hostname
  networking.hostName = "demo";

  # Setup users with super secure passwords
  users.users.root.initialHashedPassword = "$6$Lhgc/BE9pRHtz.d0$5XuvpzMm8EBXVxQuqo.ONSIF0bbDCV7BDNhuBMiNQxJFEqB3vd1/6yJrQSpKYUSVMsPY2i.RzwCCMo4Uo6dtr.";
  users.users.demo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialHashedPassword = "$6$FG1kjCgAXNEVQFMu$nllG3t93Qd8vcGBbho8yc8cHibLzwe5/nMCTcdJfrNvZHxlopxt4r6dyS28NSM90.4gQdgEvLwNTu0TYOiR7D.";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB4h5HZCnD2uFkpb8Z/pPQKXrtdV5YU3DG1w+9rOyddy mmazzanti@beta.xi"
    ];
  };

  # Basic environment
  environment.systemPackages = with pkgs; [
    wget
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
  };

  # Required for mutable file compatibility
  system.stateVersion = "22.11";
}
