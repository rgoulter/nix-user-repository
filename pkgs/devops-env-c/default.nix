{pkgs}:
pkgs.buildEnv {
  name = "devops-env-c";
  paths = with pkgs; [
    awscli2
    aws-mfa
    bat
    bottom
    coreutils
    csvkit
    ctags
    direnv
    fd
    fish
    fzf
    gawk
    git
    google-cloud-sdk
    helix
    htop
    jq
    k9s
    kubectl
    mariadb
    lazydocker
    lazygit
    less
    neovim
    nodePackages.bash-language-server
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
