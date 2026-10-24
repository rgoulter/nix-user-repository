{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages.llm-agents = import ./default.nix {
      inherit pkgs;
      # Use the flake's own package set (hits cache.numtide.com). Do not follow
      # our nixpkgs here: shared-nixpkgs only caches when revisions match.
      llmAgentsPkgs = inputs.llm-agents.packages.${system};
    };
  };
}
