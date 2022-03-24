{ pkgs }:

let
  emacsWithProfileDoomApplication =
    pkgs.writeTextFile {
      name = "chemacs-doom";
      destination = "/share/applications/emacs-doom.desktop";
      text = ''
        [Desktop Entry]
        Name=Emacs (Doom)
        GenericName=Text Editor
        Comment=Edit text
        MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
        Exec=emacs --with-profile doom %F
        Icon=emacs
        Type=Application
        Terminal=false
        Categories=Development;TextEditor;
        StartupWMClass=Emacs
        Keywords=Text;Editor;
      '';
    };
  emacsWithProfileSpacemacsApplication =
    pkgs.writeTextFile {
      name = "chemacs-spacemacs";
      destination = "/share/applications/emacs-spacemacs.desktop";
      text = ''
        [Desktop Entry]
        Name=Emacs (Spacemacs)
        GenericName=Text Editor
        Comment=Edit text
        MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
        Exec=emacs --with-profile spacemacs %F
        Icon=emacs
        Type=Application
        Terminal=false
        Categories=Development;TextEditor;
        StartupWMClass=Emacs
        Keywords=Text;Editor;
      '';
    };
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
    bash
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
    exa
    fd
    findutils
    fish
    fzf
    fzy
    gawk
    git
    gitAndTools.tig
    glances
    gnupg
    google-cloud-sdk
    htop
    jq
    k9s
    kakoune
    # 2022-01-23: macOS: kitty tests failed w/ permission issues
    (kitty.overrideAttrs (oa: { doInstallCheck = false; }))
    kubectl
    lazydocker
    lazygit
    less
    # 2021-01-26: macOS: neovim, temporarily broken
    # https://github.com/NixOS/nixpkgs/pull/155688
    (wrapNeovim (neovim-unwrapped.overrideAttrs (oa: { NIX_LDFLAGS = [ ]; })) { })
    nix
    openssh
    procps
    python38Packages.powerline
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
    (keepassxc.overrideAttrs (oa: { doCheck = false; }))
    pinentry_mac
  ]) ++ (lib.optionals stdenv.isLinux [
    desktop-file-utils
    emacsWithProfileDoomApplication
    emacsWithProfileSpacemacsApplication
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
