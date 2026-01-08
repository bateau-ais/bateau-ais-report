{
  description = "Code source du rapport de projet 5A sur la détection d'anomalie sur les systèmes AIS.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      tex = pkgs.texlive.combine {
        inherit
          (pkgs.texlive)
          scheme-medium
          adjustbox
          babel-german
          background
          bidi
          collectbox
          csquotes
          everypage
          filehook
          floatrow
          footmisc
          footnotebackref
          framed
          fvextra
          graphics
          letltxmacro
          ly1
          mdframed
          mweights
          needspace
          pagecolor
          sourcecodepro
          sourcesanspro
          titling
          ucharcat
          ulem
          unicode-math
          upquote
          xecjk
          xurl
          zref
          ;
      };

      eisvogelTemplate = pkgs.fetchurl {
        url = "https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v3.2.1/Eisvogel.zip";
        sha256 = "sha256-X7RQd9wsV+SFqoIUpFUCyu3ZfpnFC/XM+VaZm3zVAfw="; # You'll need to update this hash
      };

      pandoc-template = pkgs.stdenv.mkDerivation {
        name = "pandoc-template";

        src = null;

        buildInputs = [pkgs.unzip pkgs.gnupatch];

        unpackPhase = ":";

        buildPhase = ''
          # Extract Eisvogel template
          mkdir -p templates
          ${pkgs.unzip}/bin/unzip ${eisvogelTemplate} -d templates/

          # Apply patch to modify author separator with tighter spacing
          ${pkgs.gnupatch}/bin/patch -p0 -d templates/Eisvogel-3.2.1 < ${./eisvogel-author-spacing.patch}
        '';

        installPhase = ''
          # Install Eisvogel template
          mkdir -p $out/share/pandoc/templates
          cp templates/Eisvogel-3.2.1/eisvogel.latex $out/share/pandoc/templates/
        '';
      };

      pandoc-wrapped = pkgs.writeShellScriptBin "pandoc" ''
        exec ${pkgs.pandoc}/bin/pandoc \
          --data-dir=${pkgs.symlinkJoin {
          name = "pandoc-data-dir";
          paths = [
            (pandoc-template + "/share/pandoc")
          ];
        }} \
          "$@"
      '';

      buildInputs = with pkgs; [
        pandoc-wrapped
        haskellPackages.pandoc-crossref
        pandoc-include
        mermaid-filter
        tex
        git
        nodePackages.mermaid-cli
      ];

      shellHook = ''
        export FONTCONFIG_FILE=${pkgs.makeFontsConf {
          fontDirectories = with pkgs; [
            nerd-fonts.overpass
            nerd-fonts.caskaydia-cove
          ];
        }}
      '';
    in {
      # Enhanced development shell with aliases and shortcuts
      devShells.default = pkgs.mkShell {
        inherit buildInputs;
        inherit shellHook;
      };

      packages.default = pkgs.stdenv.mkDerivation {
        name = "bateau-ais-report";

        inherit buildInputs;
        preBuild = shellHook;
        src = ./.;

        buildPhase = ''
          runHook preBuild

          # Set up Tectonic cache directory in the build environment
          export XDG_CACHE_HOME=$TMPDIR/cache
          mkdir -p $XDG_CACHE_HOME

          # Use network access for Tectonic downloads
          export HOME=$TMPDIR

          make

          runHook postBuild
        '';

        installPhase = ''
          mkdir -p $out
          cp -r dist/* $out/
        '';

        phases = ["unpackPhase" "buildPhase" "installPhase"];
      };
    });
}
