{pkgs, ...}: {
  # Neovim text editor configuration
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
  };
}
