# "-lite", as in, without the desktop applications.
{
  pkgs,
  makeEmacsChemacsProfile,
}: let
  emacsWithProfileDoomApplication = makeEmacsChemacsProfile {
    profileName = "doom";
    displayName = "Doom";
  };
  emacsWithProfileSpacemacsApplication = makeEmacsChemacsProfile {
    profileName = "spacemacs";
    displayName = "Spacemacs";
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
        comma
        coreutils
        ctags
        direnv
        docker
        ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [
          epkgs.vterm
        ]))
        emacs-all-the-icons-fonts
        emacsWithProfileDoomApplication
        exa
        fd
        findutils
        fish
        fzf
        gawk
        git
        gitAndTools.tig
        glances
        gnupg
        helix
        htop
        jq
        kitty
        kubectl
        lazydocker
        lazygit
        less
        neovim
        nix
        openssh
        procps
        # Python 3 needed for Tmux extracto
        python3
        ripgrep
        # ruby needed for tmux-jump
        ruby
        starship
        tldr
        tmux
        wget
        which
      ]
      ++ (lib.optionals true [
        ])
      ++ (lib.optionals stdenv.isDarwin [
        pinentry
        pinentry_mac
      ])
      ++ (lib.optionals stdenv.isLinux [
        onedrive
        pinentry
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
