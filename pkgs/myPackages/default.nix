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
in
pkgs.buildEnv {
  name = "my-packages";
  paths = with pkgs; [
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
    keepassxc
    # 2022-01-23: macOS: kitty tests failed w/ permission issues
    (kitty.overrideAttrs(oa: { doInstallCheck = false; }))
    kubectl
    lazydocker
    lazygit
    less
    # 2021-01-26: macOS: neovim, temporarily broken
    # https://github.com/NixOS/nixpkgs/pull/155688
    (wrapNeovim (neovim-unwrapped.overrideAttrs (oa: { NIX_LDFLAGS = []; })) { })
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
  ]) ++(lib.optionals stdenv.isDarwin [
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
    lens
    obs-studio
    onedrive
    pinentry_gtk2
    slack
    spotify
    tdesktop
    vlc
  ]);
  pathsToLink = ["/bin" "/lib" "/share" ] ++ (with pkgs; lib.optionals stdenv.isDarwin [ "/Applications" "/Library" ]);
}
