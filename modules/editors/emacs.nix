{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.editors.emacs;
in
# doomCommit = "424b7af45fa2c96bbee9b06f33c6cd0fc13412ac";
{
  options.modules.editors.emacs = {
    enable = mkEnableOption "Enable Emacs support";
  };

  config = mkIf cfg.enable {
    # TODO clone doom in .config?
    services.emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
      defaultEditor = true;
      startWithUserSession = "graphical";
      client = {
        enable = true;
      };
    };
    home.sessionPath = [
      "$HOME/.config/emacs/bin"
    ];
    home.activation = {
      doomInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ ! -d "$HOME/.config/emacs" ]; then
          ${pkgs.git}/bin/git clone --depth 1 https://github.com/doomemacs/doomemacs $HOME/.config/emacs
        fi
      '';
    };

    home.packages = with pkgs; [
      emacs29-pgtk
      emacsPackages.vterm
      emacsPackages.python
      emacsPackages.emacsql
      emacsPackages.pdf-tools

      # requirements
      libtool
      ripgrep
      fd
      pandoc
      (texlive.combine { inherit (texlive) scheme-full minted; })
      (python3.withPackages (ps: with ps; [ pygments ]))
      clang
      imagemagick
      zstd
      gnutls
      nixfmt-rfc-style
      nil
    ];
  };
}