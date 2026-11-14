{
  description = "knowledge-base-kit: knowledge base conventions, and the checker that enforces them (link validation, linting, backlink scanning)";

  # scions/living-specifications is a git submodule (graft v2.13.0)
  inputs.self.submodules = true;
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    graft = { url = "github:danielnaab/graft/v2.13.1"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, graft, ... }@inputs:
    graft.lib.mkFlake {
      inherit inputs;
      # The kit's tools and check come from graft.nix, exactly as a repo that grafts the kit gets them, so
      # they are defined once: packages.<system>.tools, an app per tool (`nix run .#kb-lint` from a knowledge
      # base's root), and checks.<system>.kb, the kit's own docs against its conventions.
      perSystem = { pkgs, lib, system, scions, ... }:
        let
          kit = consumer: import ./graft.nix { inherit pkgs lib system scions consumer; scion = self; };
          own = kit self;
          app = drv: { type = "app"; program = lib.getExe drv; meta.description = drv.meta.description; };
        in
        {
          inherit (own) tools;
          apps = lib.mapAttrs (_: app) own.tools;
          checks = own.checks // {
            # graft.nix's contract: the four tools, and a check only where there is a knowledge-base.yaml
            graft-nix =
              let bare = kit "${self}/src"; in  # a subpath of self, not a fresh store copy: valid under --no-build
              assert lib.assertMsg (lib.attrNames own.tools == [ "check-links" "kb-lint" "kb-validate" "scan-backlinks" ])
                "graft.nix: tools are ${toString (lib.attrNames own.tools)}";
              assert lib.assertMsg (lib.attrNames own.checks == [ "kb" ]) "graft.nix: a knowledge base gets the kb check";
              assert lib.assertMsg (bare.checks == { }) "graft.nix: a repo without knowledge-base.yaml gets no check";
              pkgs.runCommand "graft-nix-test" { nativeBuildInputs = lib.attrValues own.tools; } ''
                mkdir -p kb/docs && cd kb
                printf 'apiVersion: kb/v1\nname: t\n' > knowledge-base.yaml
                printf -- '---\nstatus: draft\n---\n# A\n\n[gone](missing.md)\n' > docs/a.md
                if check-links > links.json; then echo "check-links passed a broken link"; exit 1; fi
                grep -q '"broken": 1' links.json
                check-links --report-only . > /dev/null
                if kb-validate . > /dev/null; then echo "kb-validate passed a broken link"; exit 1; fi
                kb-lint --report-only > /dev/null
                scan-backlinks > /dev/null
                touch $out
              '';
          };
        };
    };
}
