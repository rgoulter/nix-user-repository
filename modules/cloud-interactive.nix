# for interactive usage of cloud VMs,
# I want nice-to-have things like
# a better shell (fish), a better editor (helix),
{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    direnv
    fd
    fish
    git
    helix
    jq
    ripgrep
    starship
    tmux
  ];
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  security.sudo.wheelNeedsPassword = false;
}
