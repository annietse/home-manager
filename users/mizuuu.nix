{ config, pkgs, ... }:

{
  imports = [ ../modules ];
  home.username = "mizuuu";
  home.homeDirectory = "/home/mizuuu";

  home.packages = with pkgs; [
    # web dev
    nodejs_24
    pnpm
    typescript
    typescript-language-server
    prettierd
    nodePackages_latest.prettier

    turbo
    deno
    rustup
  ];

  home.file = {
  };

  home.sessionVariables = {
    DISPLAY = "172.29.64.1:0.0";
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.dates = "weekly";
    flake = "/home/mizuuu/.config/home-manager";
  };

  modules = {
    editors = {
      emacs.enable = true;
    };

    shell = {
      cli-tools = {
        enable = true;
        git-sign = true;
      };
    };
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
  #  /etc/profiles/per-user/aknee/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # ------- DO NOT CHANGE ---------
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
