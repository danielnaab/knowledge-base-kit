{
  description = "knowledge-base-kit: knowledge base conventions, and the checker that enforces them (link validation, linting, backlink scanning)";

  # scions/living-specifications is a git submodule, a pattern (tuteur). The folder keeps graft's name, set as
  # dir below: tuteur 0.2.0 no longer finds scions/ without it.
  inputs.self.submodules = true;
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    tuteur = { url = "github:danielnaab/tuteur/v0.1.0"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, tuteur, ... }@inputs:
    tuteur.lib.mkFlake {
      inherit inputs;
      dir = "scions";
      # The kit's tools and check come from tuteur.nix, exactly as a repo that takes the kit gets them, so
      # they are defined once: packages.<system>.tools, an app per tool (`nix run .#kb-lint` from a knowledge
      # base's root), and checks.<system>.kb, the kit's own docs against its conventions.
      perSystem = { pkgs, lib, system, patterns, ... }:
        let
          kit = consumer: import ./tuteur.nix { inherit pkgs lib system patterns consumer; pattern = self; };
          own = kit self;
          app = drv: { type = "app"; program = lib.getExe drv; meta.description = drv.meta.description; };
        in
        {
          inherit (own) tools;
          apps = lib.mapAttrs (_: app) own.tools;
          checks = own.checks // {
            # tuteur.nix's contract: the four tools, and a check only where there is a knowledge-base.yaml
            tuteur-nix =
              let bare = kit "${self}/src"; in  # a subpath of self, not a fresh store copy: valid under --no-build
              assert lib.assertMsg (lib.attrNames own.tools == [ "check-links" "kb-lint" "kb-validate" "scan-backlinks" ])
                "tuteur.nix: tools are ${toString (lib.attrNames own.tools)}";
              assert lib.assertMsg (lib.attrNames own.checks == [ "kb" ]) "tuteur.nix: a knowledge base gets the kb check";
              assert lib.assertMsg (bare.checks == { }) "tuteur.nix: a repo without knowledge-base.yaml gets no check";
              pkgs.runCommand "tuteur-nix-test" { nativeBuildInputs = lib.attrValues own.tools; } ''
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
