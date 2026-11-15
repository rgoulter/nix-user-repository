# Flake commands for day-to-day development.

# file+file:// reads this file; its contents must be the project path.
devenv-root-file := justfile_directory() / ".devenv" / "root"
devenv-root := "file+file://" + devenv-root-file

# Show available recipes
default:
    @just --list

# Write the project path for the devenv-root flake input.
_devenv-root:
    mkdir -p "{{ justfile_directory() }}/.devenv"
    printf %s "{{ justfile_directory() }}" > "{{ devenv-root-file }}"

# Build workstation (same as plain `nix build`)
alias b := build

build: _devenv-root
    nix build --override-input devenv-root "{{ devenv-root }}"

# Run all flake checks (formatting, etc.)
alias c := check

check: _devenv-root
    nix flake check --override-input devenv-root "{{ devenv-root }}"

# Format the repository
alias f := fmt

fmt:
    nix fmt
