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

    # tmux
    programs.tmux = {
      enable = true;
      prefix = "C-s";
      secureSocket = false;
      baseIndex = 1;
      plugins = with pkgs; [
        tmuxPlugins.cpu
        tmuxPlugins.battery
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g default-terminal "tmux-256color"

            # Configure the catppuccin plugin
            set -g @catppuccin_flavor "mocha"
            set -g @catppuccin_window_status_style "rounded"

            # Load catppuccin
            # run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux
            # For TPM, instead use `run ~/.tmux/plugins/tmux/catppuccin.tmux`
            run ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
            run ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux

            # Configure CPU plugin
            set -g @cpu_percentage_format "%3.0f%%"

            # Configure battery plugin
            set -g @batt_icon_status_charging "⚡"
            set -g @batt_icon_status_discharging "🔋"

            # Make the status line pretty and add some modules
            set -g status-right-length 100
            set -g status-left-length 100
            set -g status-left ""
            set -g status-right ""
            set -agF status-right "#{E:@catppuccin_status_cpu}"
            set -ag status-right "#{E:@catppuccin_status_session}"
            set -ag status-right "#{E:@catppuccin_status_uptime}"
            set -agF status-right "#{E:@catppuccin_status_battery}"
          '';
        }
      ];
      mouse = true;
      extraConfig = ''
        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        unbind r
        bind r source-file ~/.config/tmux/tmux.conf

        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        bind-key s split-window -v
        bind-key v split-window -h

        bind-key [ next-window
        bind-key ] next-window

        set-option -g status-position top
      '';
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
    services.gpg-agent = {
      enable = true;
      # Set pinentry program
      # pinentry.package = pkgs.pinentry-gtk2;
      # Alternative options:
      # pinentry.package = pkgs.pinentry-curses;   # For terminal
      # pinentry.package = pkgs.pinentry-qt;      # For Qt desktop
      pinentry.package = pkgs.pinentry-gnome3; # For GNOME
      # Optional: Enable SSH support
      enableSshSupport = true;
      # Optional: Set default cache TTL
      defaultCacheTtl = 3600;
      maxCacheTtl = 86400;
      # Optional: Extra config
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
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
      nvchad

      pinentry-gtk2
    ];
  };
}
