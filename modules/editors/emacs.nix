{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  iosevkaAile = pkgs.fetchzip {
    url = "https://github.com/be5invis/Iosevka/releases/download/v31.6.0/PkgTTC-IosevkaAile-31.6.0.zip";
    sha256 = "sha256-nHDisG2njkb2+XX7UUCUQVbVCPUQW3zdgwmPqR5wYK4=";
    stripRoot = false;
  };
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
      package = pkgs.emacs;
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
      emacs
      emacsPackages.vterm
      emacsPackages.python
      emacsPackages.emacsql
      emacsPackages.pdf-tools

      # requirements
      aspell
      aspellDicts.en
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      # Ioveska Aile
      (stdenv.mkDerivation {
        name = "iosevka-aile";
        src = iosevkaAile;
        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          cp *.ttc $out/share/fonts/truetype/
        '';
      })
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