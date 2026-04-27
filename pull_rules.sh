#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  bash ./pull_rules.sh

Examples:
  bash ./pull_rules.sh

The script copies the latest .rules_v4 directory from the source repository
into the current repository as .rules.
USAGE
}

DEFAULT_SOURCE_REPO="yuki746289/product_agent_rules"
DEFAULT_RULE_DIR=".rules_v4"

normalize_repo_url() {
  local repo="$1"

  if [[ "$repo" == *"://"* || "$repo" == git@* ]]; then
    printf '%s\n' "$repo"
    return
  fi

  if [[ "$repo" == */* ]]; then
    printf 'https://github.com/%s.git\n' "$repo"
    return
  fi

  printf '%s\n' "$repo"
}

require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Error: '$command_name' is required." >&2
    exit 1
  fi
}

confirm() {
  local prompt="$1"
  local answer

  while true; do
    read -r -p "$prompt [y/yes/n/no]: " answer
    case "${answer,,}" in
      y|yes)
        return 0
        ;;
      n|no|"")
        return 1
        ;;
      *)
        echo "Please answer y, yes, n, or no."
        ;;
    esac
  done
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "$#" -gt 0 ]]; then
  echo "Error: arguments are not supported. Run: bash ./pull_rules.sh" >&2
  usage >&2
  exit 1
fi

require_command git

source_repo="$DEFAULT_SOURCE_REPO"

if [[ -z "$source_repo" ]]; then
  echo "Error: source repository is required." >&2
  usage >&2
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: run this script inside the destination Git repository." >&2
  exit 1
fi

repo_root="$(git rev-parse --show-toplevel)"
source_url="$(normalize_repo_url "$source_repo")"
tmp_dir="$(mktemp -d)"

cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

clone_args=(clone --depth 1)
clone_args+=("$source_url" "$tmp_dir/source")

echo "Cloning source repository..."
git "${clone_args[@]}" >/dev/null

selected_dir="$DEFAULT_RULE_DIR"
source_path="$tmp_dir/source/$selected_dir"

if [[ ! -d "$source_path" ]]; then
  echo "Error: '$selected_dir' was not found in the source repository." >&2
  exit 1
fi

destination_path="$repo_root/.rules"

if [[ -e "$destination_path" ]]; then
  echo
  echo "'.rules' already exists and will be replaced with '$selected_dir'."
  echo "This removes the current '.rules' directory before copying the selected one."
  if ! confirm "Replace '.rules'?"; then
    echo "Canceled."
    exit 0
  fi
  rm -rf "$destination_path"
fi

cp -R "$source_path" "$destination_path"

echo
echo "Pulled '$selected_dir' into '.rules':"
echo "  $destination_path"
echo
echo "Review changes with:"
echo "  git status --short"
echo "  git diff --stat"
