# for interactive usage of cloud VMs,
# I want nice-to-have things like
# a better shell (fish), a better editor (helix),
{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    direnv
    fd
    fish
    git
    helix
    ripgrep
    tmux
  ];
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  security.sudo.wheelNeedsPassword = false;
}
