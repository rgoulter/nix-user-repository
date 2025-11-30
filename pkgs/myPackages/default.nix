{
  pkgs,
  makeEmacsChemacsProfile,
}: let
  emacsWithProfileDoomApplication = makeEmacsChemacsProfile {
    profileName = "doom";
    displayName = "Doom";
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
    paths = with pkgs;
      [
        (runCommand "profile" {} ''
          mkdir -p $out/etc/profile.d
          cp ${myProfile} $out/etc/profile.d/my-profile.sh
        '')
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
        broot
        comma
        coreutils
        ctags
        delta
        difftastic
        direnv
        docker
        ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [
          epkgs.vterm
          epkgs.treesit-grammars.with-all-grammars
        ]))
        emacs-all-the-icons-fonts
        emacsWithProfileDoomApplication
        eza
        fd
        findutils
        fish
        fzf
        gawk
        git
        git-absorb
        gitAndTools.tig
        glances
        gnupg
        helix
        htop
        jq
        just
        kitty
        kubectl
        lazydocker
        lazygit
        ledger
        less
        mcfly
        navi
        # required for GitHub's CoPilot.vim
        nodejs
        neovim
        openssh
        procps
        # Python 3 needed for Tmux extracto
        python3
        rclone
        ripgrep
        # ruby needed for tmux-jump
        ruby
        skim
        starship
        tldr
        tmux
        tmuxPlugins.tmux-thumbs
        watchexec
        wget
        which
        zellij
      ]
      ++ (lib.optionals true [
        ])
      ++ (lib.optionals stdenv.isDarwin [
        # 2022-02-06: macOS testykchallengeresponsekey is failing
        # 2022-05-10: KeePass needs newer macOS
        # (keepassxc.overrideAttrs (_: { doCheck = false; }))
        pinentry_mac
        # Unfree software; requires config.allowUnfree = true
        vscode
        # (vscode-with-extensions.override {
        #   vscodeExtensions = with vscode-extensions; [
        #     matklad.rust-analyzer
        #     ms-python.python
        #     # mkhl.direnv
        #   ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        #     {
        #       name = "direnv";
        #       publisher = "mkhl";
        #       version = "0.6.1";
        #       sha256 = "sha256-5/Tqpn/7byl+z2ATflgKV1+rhdqj+XMEZNbGwDmGwLQ=";
        #     }
        #   ];
        # })
      ])
      ++ (lib.optionals stdenv.isLinux [
        desktop-file-utils
        (firefox.override {
          nativeMessagingHosts = [
            tridactyl-native
          ];
        })
        freecad
        # Unfree software; requires config.allowUnfree = true
        google-chrome
        (gimp-with-plugins.override {plugins = with gimpPlugins; [bimp];})
        inkscape
        keepassxc
        kicad
        openscad
        photoqt
        pinentry-gtk2
        # qmk: works on macOS, too,
        # but my macOS is not very powerful
        qmk
        # Unfree software; requires config.allowUnfree = true
        slack
        # Unfree software; requires config.allowUnfree = true
        spotify
        tdesktop
        vlc
        # Unfree software; requires config.allowUnfree = true
        vscode
        xclip
        yubikey-touch-detector
      ]);
    extraOutputsToInstall = ["man" "doc" "info"];
    pathsToLink =
      [
        "/bin"
        "/etc"
        "/lib"
        "/share"
      ]
      ++ (with pkgs;
        lib.optionals stdenv.isDarwin [
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
