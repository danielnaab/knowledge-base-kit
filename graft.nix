# What a repository that grafts knowledge-base-kit gets (graft v2.13.0 or later reads this file).
#
# tools (on PATH through the repo's packages.<system>.tools; each takes the knowledge base's directory,
# default `.`, and --report-only):
#   kb-lint         frontmatter status, provenance, OKF conformance (kb_linter)
#   check-links     internal Markdown links and their heading anchors (link_validator)
#   scan-backlinks  `# spec:` annotations against the specs (backlink_scanner)
#   kb-validate     check-links, then kb-lint's findings as a report
# checks: `kb` (checks.<system>.knowledge-base-kit-kb): check-links and kb-lint on the repo, when it has a
#   knowledge-base.yaml at the top of its flake's source; none otherwise.
# For a sibling scion: scions.knowledge-base-kit.src, the checker's Python sources (PYTHONPATH).
{ pkgs, lib, scion, consumer, ... }:
let
  src = "${scion}/src";
  tool = name: description: text: pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [ pkgs.python3 ];
    text = ''
      export PYTHONPATH=${src} PYTHONDONTWRITEBYTECODE=1
      ${text}
    '';
    meta.description = description;
  };
in
{
  inherit src;

  tools = {
    kb-lint = tool "kb-lint" "Check frontmatter status, provenance and OKF conformance"
      ''exec python3 -m kb_linter "$@"'';
    check-links = tool "check-links" "Find broken internal Markdown links and heading anchors"
      ''exec python3 -m link_validator "$@"'';
    scan-backlinks = tool "scan-backlinks" "Trace specs to their implementations"
      ''exec python3 -m backlink_scanner "$@"'';
    kb-validate = tool "kb-validate" "Check links, then report lint findings"
      ''python3 -m link_validator "$@" && exec python3 -m kb_linter --report-only "$@"'';
  };

  # A repo without a knowledge-base.yaml (or a flake in a subdirectory, whose source is that directory)
  # gets no check.
  checks = lib.optionalAttrs (builtins.pathExists "${consumer}/knowledge-base.yaml") {
    kb = pkgs.runCommand "knowledge-base-kit-check" { nativeBuildInputs = [ pkgs.python3 ]; } ''
      cd ${consumer}
      export PYTHONPATH=${src} PYTHONDONTWRITEBYTECODE=1
      # one command per line: under set -e, a failure left of `&&` would not stop the build
      python3 -m link_validator .
      python3 -m kb_linter .
      touch $out
    '';
  };
}
