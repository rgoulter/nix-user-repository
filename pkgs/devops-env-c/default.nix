{ pkgs }:

pkgs.buildEnv {
  name = "devops-env-c";
  paths = with pkgs; [
    awscli2
    aws-mfa
    bat
    bottom
    coreutils
    ctags
    direnv
    fd
    fish
    fzf
    gawk
    git
    google-cloud-sdk
    htop
    jq
    k9s
    kubectl
    lazydocker
    lazygit
    less
    neovim
    ripgrep
    silver-searcher
    starship
    tmux
    tree
    vim
    wget
    which
  ];
  pathsToLink = ["/bin" "/lib" "/share"];
}
