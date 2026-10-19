# Aggregates common LLM coding-agent CLIs (and the ChatGPT/Codex desktop app)
# from github:numtide/llm-agents.nix (formerly nix-ai-tools).
#
# Attr names from that flake:
#   grok          — Grok Build TUI (xAI); binaries: grok, agent
#   codex         — OpenAI Codex CLI TUI; binary: codex
#   chatgpt       — ChatGPT / Codex desktop app; binary: chatgpt
#   copilot-cli   — GitHub Copilot CLI TUI; binary: copilot
#   claude-code   — Anthropic Claude Code TUI; binary: claude
#
# Most of these are unfree; the flake input's own packages.x86_64-linux.*
# already allow that. Prefer the numtide binary cache (see flake.nix nixConfig).
{
  pkgs,
  llmAgentsPkgs,
}:
pkgs.buildEnv {
  name = "llm-agents";
  paths = with llmAgentsPkgs; [
    grok
    codex
    chatgpt
    copilot-cli
    claude-code
  ];
  pathsToLink = [
    "/bin"
    "/share"
  ];
}
