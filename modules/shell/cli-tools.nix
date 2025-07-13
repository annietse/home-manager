{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.shell.cli-tools;
in
{
  options = {
    modules.shell.cli-tools = {
      enable = mkEnableOption "Enables CLI Tools";
      git-username = lib.mkOption {
        default = "Atri Hegde";
        description = ''
          Your git username
        '';
      };
      git-email = lib.mkOption {
        default = "iamatrihegde@outlook.com";
        description = ''
          Your git email
        '';
      };
      git-sign = mkEnableOption "Sign commits with GPG";
      git-signingkey = lib.mkOption {
        default = "0DB99C10334E736E";
        description = ''
          Your GPG key Identifier
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Basic ZSH
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
      };
      syntaxHighlighting.enable = true;
      dotDir = ".config/zsh";
      initContent = ''
        # Key bindings for Home and End keys
        bindkey "^[[H" beginning-of-line     # Home key
        bindkey "^[[F" end-of-line           # End key
        bindkey "^[[1~" beginning-of-line    # Home key (alternative)
        bindkey "^[[4~" end-of-line          # End key (alternative)

        # For different terminal emulators
        bindkey "^[OH" beginning-of-line     # Home key (xterm)
        bindkey "^[OF" end-of-line           # End key (xterm)

        # Additional useful bindings
        bindkey "^[[3~" delete-char          # Delete key
        bindkey "^[[5~" history-search-backward  # Page Up
        bindkey "^[[6~" history-search-forward   # Page Down
      '';
    };

    # Git
    programs.git =
      {
        enable = true;
        userName = cfg.git-username;
        userEmail = cfg.git-email;
        delta = {
          enable = true;
        };
        extraConfig = {
          init.defaultBranch = "master";
        };
      }
      // (
        if cfg.git-sign then
          {
            signing = {
              signByDefault = true;
              key = cfg.git-signingkey;
            };
          }
        else
          { }
      );
    # git aliases
    programs.zsh.shellAliases = {
      ga = "git add .";
      gc = "git commit -m";
      gp = "git push";
      gfp = "git push --force-with-lease";
      gf = "git pull";
      grc = "git rebase --continue";
      gra = "git rebase --abort";
      grs = "git reset --soft HEAD~1";
      grh = "git reset --hard HEAD~1";
      gcl = "git clone";
      gco = "git checkout";
      gs = "git status";
      gtc = "git tag -a -m";
      gtp = "git push --tags";
    };

    # eza
    programs.eza = {
      enable = true;
      icons = "always";
      enableZshIntegration = true;
    };

    # Starship
    programs.starship = {
      enable = true;
    };

    # Zoxide
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.zsh.shellAliases = {
      cd = "z";
    };

    # Direnv + nix-direnv
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    # Editorconfig
    editorconfig.enable = true;

    # Ripgrep
    programs.ripgrep = {
      enable = true;
    };

    # fd
    programs.fd = {
      enable = true;
    };

    # GNU GPG
    programs.gpg = {
      enable = true;
    };

    # btop
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "Default";
        theme_background = false;
      };
    };

    programs.joshuto = {
      enable = true;
    };

    home.packages = with pkgs; [
      zip
      _7zz
      unzip
      pfetch
      bat
      gnumake
      cmake

      pinentry-gtk2
    ];
  };
}
