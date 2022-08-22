{ pkgs
, makeEmacsChemacsProfile
}:

let
  emacsWithProfileDoomApplication =
    makeEmacsChemacsProfile { profileName = "doom"; displayName = "Doom"; };
  emacsWithProfileSpacemacsApplication =
    makeEmacsChemacsProfile { profileName = "spacemacs"; displayName = "Spacemacs"; };
  # h/t https://nixos.org/manual/nixpkgs/stable/#sec-gnu-info-setup
  myProfile = pkgs.writeText "my-profile" ''
    export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/sbin:/bin:/usr/sbin:/usr/bin
    export MANPATH=$HOME/.nix-profile/share/man:/nix/var/nix/profiles/default/share/man:/usr/share/man
    export INFOPATH=$HOME/.nix-profile/share/info:/nix/var/nix/profiles/default/share/info:/usr/share/info
  '';
in
pkgs.buildEnv {
  name = "my-packages";
  paths = with pkgs; [
    (runCommand "profile" { } ''
      mkdir -p $out/etc/profile.d
      cp ${myProfile} $out/etc/profile.d/my-profile.sh
    '')
    alacritty
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.vi
    awscli2
    aws-mfa
    babelfish
    bashInteractive
    bat
    bottom
    coreutils
    ctags
    direnv
    docker
    ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [
      epkgs.vterm
    ]))
    emacs-all-the-icons-fonts
    emacsWithProfileDoomApplication
    emacsWithProfileSpacemacsApplication
    exa
    fd
    findutils
    fish
    fzf
    fzy
    gawk
    git
    gitAndTools.tig
    # 2022-06-13: didn't build on macos
    # glances
    gnupg
    google-cloud-sdk
    helix
    htop
    jq
    k9s
    kakoune
    # 2022-01-23: macOS: kitty tests failed w/ permission issues
    (kitty.overrideAttrs (_: { doInstallCheck = false; }))
    kubectl
    lazydocker
    lazygit
    less
    # 2021-01-26: macOS: neovim, temporarily broken
    # https://github.com/NixOS/nixpkgs/pull/155688
    (wrapNeovim (neovim-unwrapped.overrideAttrs (_: { NIX_LDFLAGS = [ ]; })) { })
    nix
    openssh
    procps
    python38Packages.powerline
    qmk
    ripgrep
    # ruby needed for tmux-jump
    ruby
    safe
    silver-searcher
    skim
    starship
    texinfoInteractive
    tldr
    tmate
    tmux
    tree
    vim
    wget
    which
  ] ++ (lib.optionals true [
    # Unfree software; requires config.allowUnfree = true
    vscode
  ]) ++ (lib.optionals stdenv.isDarwin [
    # 2022-02-06: macOS testykchallengeresponsekey is failing
    # 2022-05-10: KeePass needs newer macOS
    # (keepassxc.overrideAttrs (_: { doCheck = false; }))
    pinentry_mac
  ]) ++ (lib.optionals stdenv.isLinux [
    desktop-file-utils
    (firefox.override {
      cfg = {
        enableTridactylNative = true;
      };
    })
    google-chrome
    keepassxc
    lens
    obs-studio
    onedrive
    pinentry_gtk2
    slack
    spotify
    tdesktop
    thunderbird
    vlc
  ]);
  extraOutputsToInstall = [ "man" "doc" "info" ];
  pathsToLink = [
    "/bin"
    "/etc"
    "/lib"
    "/share"
  ] ++ (with pkgs; lib.optionals stdenv.isDarwin [
    "/Applications"
    "/Library"
  ]);
  postBuild = ''
    if [ -x $out/bin/install-info -a -w $out/share/info ]; then
      shopt -s nullglob
      for i in $out/share/info/*.info $out/share/info/*.info.gz; do
          $out/bin/install-info $i $out/share/info/dir
      done
    fi
  '';
}
