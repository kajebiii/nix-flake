{config, pkgs, nixpkgs-unstable, lib, ...}:
let system = "aarch64-darwin";
in
[
  (final: prev: {
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  })
  (final: prev: {
    ccusage = pkgs.stdenv.mkDerivation rec {
      pname = "ccusage";
      version = "18.0.10";

      src = pkgs.fetchurl {
        url = "https://registry.npmjs.org/ccusage/-/ccusage-${version}.tgz";
        hash = "sha512-bVNqaBFLo3lnSV6afiV/wtLselkGQLV4iXltcTRJwoqbDnnutw6ZNliF1CYwpF/7M0xsmXZnExR0CxdDSdT9xg==";
      };

      nativeBuildInputs = [ pkgs.makeWrapper ];
      buildInputs = [ pkgs.nodejs ];

      unpackPhase = ''
        mkdir -p source
        tar xzf $src --strip-components=1 -C source
      '';

      installPhase = ''
        mkdir -p $out/lib/ccusage $out/bin
        cp -r source/* $out/lib/ccusage/
        makeWrapper ${pkgs.nodejs}/bin/node $out/bin/ccusage \
          --add-flags "$out/lib/ccusage/dist/index.js"
      '';
    };
  })
  (final: prev: {
    agent-slack = pkgs.stdenv.mkDerivation rec {
      pname = "agent-slack";
      version = "0.6.1";

      src = pkgs.fetchurl {
        url = "https://registry.npmjs.org/agent-slack/-/agent-slack-${version}.tgz";
        hash = "sha512-tZ1oBHJO3D2nQC6+nuEoy1t9vQQtgBcuPEz+P/Bu4cAbcki8QWCQtiBbRNYLSnnrhpC8izoN8qeR+4ISPKALLQ==";
      };

      nativeBuildInputs = [ pkgs.makeWrapper ];
      buildInputs = [ pkgs.nodejs ];

      unpackPhase = ''
        mkdir -p source
        tar xzf $src --strip-components=1 -C source
      '';

      installPhase = ''
        mkdir -p $out/lib/agent-slack $out/bin
        cp -r source/* $out/lib/agent-slack/
        makeWrapper ${pkgs.nodejs}/bin/node $out/bin/agent-slack \
          --add-flags "$out/lib/agent-slack/dist/index.js"
      '';
    };
  })
  (final: prev: {
    terraform-config-inspect = pkgs.buildGoModule rec {
      pname = "terraform-config-inspect";
      version = "1.6.0";

      src = pkgs.fetchFromGitHub {
        owner = "hashicorp";
        repo = "terraform-config-inspect";
        rev = "a34142ec2a72dd916592afd3247dd354f1cc7e5c";
        sha256 = "sha256-+NsVQ3K7fiQjI/41kPV3iAzFO3Z3Z4oeUA5gJgR+EyU=";
      };

      vendorHash = "sha256-JO02/PrlyFpQnNAb0ZZ8sfGiMmGjtbhwmAasWkHPg1A=";
    };
  })
]
