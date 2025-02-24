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
    ];
  };
}