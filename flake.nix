{
  description = "Code source du rapport de projet 5A sur la détection d'anomalie sur les systèmes AIS.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      tex = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-minimal latex-bin;
      };

      eisvogelTemplate = pkgs.fetchurl {
        url = "https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v3.2.1/Eisvogel.zip";
        sha256 = "sha256-X7RQd9wsV+SFqoIUpFUCyu3ZfpnFC/XM+VaZm3zVAfw="; # You'll need to update this hash
      };

      pandoc-template = pkgs.stdenv.mkDerivation {
        name = "pandoc-template";

        src = null;

        buildInputs = [ pkgs.unzip ];

        unpackPhase = ":";

        buildPhase = ''
          # Extract and install Eisvogel template
          mkdir -p templates
          ${pkgs.unzip}/bin/unzip ${eisvogelTemplate} -d templates/
        '';

        installPhase = ''
          # Install Eisvogel template
          mkdir -p $out/share/pandoc/templates
          cp templates/Eisvogel-3.2.1/eisvogel.latex $out/share/pandoc/templates/
        '';
      };

      pandoc-wrapped = pkgs.writeShellScriptBin "pandoc" ''
        exec ${pkgs.pandoc}/bin/pandoc --data-dir=${pandoc-template}/share/pandoc "$@"
      '';
      
      buildInputs = with pkgs; [
        pandoc-wrapped
        haskellPackages.pandoc-crossref
        pandoc-include
        mermaid-filter
        tectonic
        git
        nodePackages.mermaid-cli
        tex
      ];
    in {
      # Enhanced development shell with aliases and shortcuts
      devShells.default = pkgs.mkShell {
        inherit buildInputs;

        shellHook = ''
          export FONTCONFIG_FILE=${pkgs.makeFontsConf {
            fontDirectories = with pkgs; [
              nerd-fonts.overpass
              nerd-fonts.caskaydia-cove
            ];
          }}
        '';
      };
    });
}
