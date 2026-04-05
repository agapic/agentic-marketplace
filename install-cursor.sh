#!/usr/bin/env bash
set -euo pipefail

# Install HumanLayer marketplace plugins into Cursor: humanlayer-workflows
# (commands, agents, shell scripts) and ui-ux-pro-max (agent skill + data).
# Usage:
#   ./install-cursor.sh              # Install globally (~/.cursor/)
#   ./install-cursor.sh --project    # Install into current project (.cursor/)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="${SCRIPT_DIR}/plugins/humanlayer-workflows"
UI_UX_SKILL_SRC="${SCRIPT_DIR}/plugins/ui-ux-pro-max/skills/ui-ux-pro-max"

if [[ "${1:-}" == "--project" ]]; then
  TARGET=".cursor"
  echo "Installing to project: $(pwd)/.cursor/"
else
  TARGET="$HOME/.cursor"
  echo "Installing globally to: ~/.cursor/"
fi

mkdir -p "${TARGET}/commands" "${TARGET}/agents" "${TARGET}/scripts" "${TARGET}/skills"

echo "Copying commands..."
cp "${PLUGIN_DIR}/commands/"*.md "${TARGET}/commands/"

echo "Copying agents..."
cp "${PLUGIN_DIR}/agents/"*.md "${TARGET}/agents/"

echo "Copying scripts..."
cp "${PLUGIN_DIR}/scripts/"*.sh "${TARGET}/scripts/"
chmod +x "${TARGET}/scripts/"*.sh

echo "Copying skill ui-ux-pro-max..."
rm -rf "${TARGET}/skills/ui-ux-pro-max"
cp -R "${UI_UX_SKILL_SRC}" "${TARGET}/skills/"

COMMANDS=$(ls -1 "${PLUGIN_DIR}/commands/"*.md | wc -l | tr -d ' ')
AGENTS=$(ls -1 "${PLUGIN_DIR}/agents/"*.md | wc -l | tr -d ' ')
SCRIPTS=$(ls -1 "${PLUGIN_DIR}/scripts/"*.sh | wc -l | tr -d ' ')

echo ""
echo "Installed: ${COMMANDS} commands, ${AGENTS} agents, ${SCRIPTS} scripts, skill ui-ux-pro-max"
echo ""
echo "Commands available (type / in Cursor chat):"
for f in "${PLUGIN_DIR}/commands/"*.md; do
  name=$(basename "$f" .md)
  echo "  /${name}"
done
echo ""
echo "Agents available (auto-delegated by Task tool):"
for f in "${PLUGIN_DIR}/agents/"*.md; do
  name=$(basename "$f" .md)
  echo "  ${name}"
done
