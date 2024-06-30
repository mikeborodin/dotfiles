{
  description = "Home Manager configuration of mike";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fvmFlake = {
      url = "git+file:///Users/mike/personal_projects/fvm-flake";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    fvmFlake,
    ...
  }: let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    # unstablePkgs = import (fetchTarball {
    #   url = "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz";
    #   sha256 = "0i494s328s733id5z7578k6ny4v92y3lvabmmqxpzysmjqsgq35g";
    # }) { inherit system; };

  in {
    homeConfigurations."mike" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {inherit system;};

      modules = [
        {
          home = {
            username = "mike";
            homeDirectory = "/Users/mike";
            stateVersion = "24.05";
            file = {
              # # Building this configuration will create a copy of 'dotfiles/screenrc' in
              # # the Nix store. Activating the configuration will then make '~/.screenrc' a
              # # symlink to the Nix store copy.
              ".config/aerospace/aerospace.toml" = {
                source = ../aerospace.toml;
                recursive = false;
              };

              # ".config/nvim" = {
              #   source = ../nvim;
              #   recursive = true;
              # };
              ".config/tmux" = {
                source = ../tmux;
              };

              ".config/karabiner" = {
                source = ../karabiner;
                recursive = true;
              };
              # ".config/kitty" = {
              #   source = home-manager.  ../kitty;
              #   recursive = true;
              # };
              # ".config/yazi" = {
              #   source = ../yazi;
              #   recursive = false;
              # };
              ".config/ncspot" = {
                source = ../ncspot;
                recursive = true;
              };

              # # You can also set the file content immediately.
              # ".gradle/gradle.properties".text = ''
              #   org.gradle.console=verbose
              #   org.gradle.daemon.idletimeout=3600000
              # '';
            };
            packages = with pkgs; [
              # flutter
              aichat
              jq
              sad
              gh-dash
              difftastic
              jless
              htmlq
              w3m

              (azure-cli.withExtensions [azure-cli.extensions.azure-devops azure-cli.extensions.confluent])
              fvmFlake.packages.${pkgs.system}.default

              # node
              nodejs_20
              # nodePackages.yarn
              nodePackages.firebase-tools

              scrcpy
              # fvm
              python39
              pipx
              bat
              yazi
              tmux
              fzf
              spotifyd
              ncspot
              erdtree
              rustup
              gitty
              httpie
              skhd
              btop
              karabiner-elements
              gh
              neovim
              # yabai
              apktool
              temurin-bin-17
              go
              jira-cli-go
              alejandra
              xcodes
              cocoapods
              ruby_3_2
              trivy

              # test
              (pkgs.writeShellScriptBin "myhello" ''
                echo "Hello, mike!"
              '')
            ];
            sessionVariables = {
              EDITOR = "nvim";
              JAVA_HOME = "${pkgs.temurin-bin-17}";
            };
          };

          nixpkgs.config = {
            allowUnfreePredicate = pkg:
              builtins.elem (pkgs.lib.getName pkg) [
                "android-studio-stable"
              ];
          };

          # Home Manager can also manage your environment variables through
          # 'home.sessionVariables'. These will be explicitly sourced when using a
          # shell provided by Home Manager. If you don't want to manage your shell
          # through Home Manager then you have to manually source 'hm-session-vars.sh'
          # located at either
          #
          #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
          #
          # or
          #
          #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
          #
          # or
          #
          #  /etc/profiles/per-user/mike/etc/profile.d/hm-session-vars.sh
          #
          # Let Home Manager install and manage itself.
          programs.home-manager.enable = true;
        }
      ];
    };
  };
}
