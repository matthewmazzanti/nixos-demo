{ pkgs, ... }: {
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      configure = {
        customRC = builtins.readFile ./init.vim; 
        packages.nvim = with pkgs.vimPlugins; {
          start = [
            vim-nix
            gruvbox
          ];
        };
      };
    };

    git = {
      enable = true;
      config = {
        user.name = "Matthew Mazzanti";
        user.email = "matthew.mazzanti@gmail.com";
        init.defaultbranch="dev";
      };
    };
  };
}
