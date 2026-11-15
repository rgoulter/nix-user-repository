# Aggregates common LLM coding-agent CLIs (and the ChatGPT/Codex desktop app)
#  from github:numtide/llm-agents.nix (formerly nix-ai-tools).
#
# Attr names from that flake (alphabetical):
#   chatgpt       — ChatGPT / Codex desktop app; binary: chatgpt
#   claude-code   — Anthropic Claude Code TUI; binary: claude
#   codex         — OpenAI Codex CLI TUI; binary: codex
#   copilot-cli   — GitHub Copilot CLI TUI; binary: copilot
#   grok          — Grok Build TUI (xAI); binaries: grok, agent
#   grok-bot      — Grok Bot desktop app; binary: grok-bot
#   muse-code     — Meta's terminal coding agent; binary: muse
#
# Most of these are unfree; the flake input's own packages.x86_64-linux.*
#  already allow that.
# Prefer the numtide binary cache (see flake.nix nixConfig).
{
  pkgs,
  llmAgentsPkgs,
}:
pkgs.buildEnv {
  name = "llm-agents";
  paths = with llmAgentsPkgs; [
    chatgpt
    claude-code
    codex
    copilot-cli
    grok
    grok-bot
    muse-code
  ];
  pathsToLink = [
    "/bin"
    "/share"
  ];
}
