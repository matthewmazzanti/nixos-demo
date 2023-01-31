{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
  };

  outputs = { nixpkgs, ... }: {
    nixosConfigurations.bootstrap = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        {
          # Allow for flakes by default
          nix.extraOptions = "experimental-features = nix-command flakes";
        }
        ./configuration.nix
      ];
    };
  };
}
