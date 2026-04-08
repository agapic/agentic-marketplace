#!/usr/bin/env bash
set -euo pipefail

# Install all marketplace plugins into Cursor (anything under plugins/* with .cursor-plugin/plugin.json).
# Usage:
#   ./install-cursor.sh              # Install globally (~/.cursor/)
#   ./install-cursor.sh --project    # Install into current project (.cursor/)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGINS_ROOT="${SCRIPT_DIR}/plugins"

if [[ "${1:-}" == "--project" ]]; then
  TARGET="$(pwd)/.cursor"
  echo "Installing to project: ${TARGET}/"
else
  TARGET="${HOME}/.cursor"
  echo "Installing globally to: ${TARGET}/"
fi

mkdir -p "${TARGET}/commands" "${TARGET}/agents" "${TARGET}/scripts" "${TARGET}/skills" "${TARGET}/rules"

shopt -s nullglob

total_commands=0
total_agents=0
total_shell_scripts=0
total_skills=0
total_rules=0

for manifest in "${PLUGINS_ROOT}"/*/.cursor-plugin/plugin.json; do
  plugin_dir="$(dirname "$(dirname "$manifest")")"
  name="$(basename "$plugin_dir")"

  echo ""
  echo "Plugin: ${name}"

  for f in "${plugin_dir}/commands/"*.md; do
    cp "$f" "${TARGET}/commands/"
    total_commands=$((total_commands + 1))
  done

  for f in "${plugin_dir}/agents/"*.md; do
    cp "$f" "${TARGET}/agents/"
    total_agents=$((total_agents + 1))
  done

  for f in "${plugin_dir}/scripts/"*.sh; do
    cp "$f" "${TARGET}/scripts/"
    chmod +x "${TARGET}/scripts/$(basename "$f")"
    total_shell_scripts=$((total_shell_scripts + 1))
  done

  for f in "${plugin_dir}/rules/"*.mdc; do
    cp -f "$f" "${TARGET}/rules/"
    total_rules=$((total_rules + 1))
  done

  if [[ -f "${plugin_dir}/SKILL.md" ]]; then
    skill_dest="${TARGET}/skills/${name}"
    rm -rf "${skill_dest}"
    mkdir -p "${skill_dest}"
    cp "${plugin_dir}/SKILL.md" "${skill_dest}/"
    for extra in reference.md examples.md; do
      [[ -f "${plugin_dir}/${extra}" ]] && cp "${plugin_dir}/${extra}" "${skill_dest}/"
    done
    [[ -d "${plugin_dir}/scripts" ]] && cp -a "${plugin_dir}/scripts" "${skill_dest}/"
    [[ -d "${plugin_dir}/data" ]] && cp -a "${plugin_dir}/data" "${skill_dest}/"
    [[ -d "${plugin_dir}/templates" ]] && cp -a "${plugin_dir}/templates" "${skill_dest}/"
    if [[ -d "${skill_dest}/scripts" ]]; then
      find "${skill_dest}/scripts" -type f \( -name "*.sh" -o -name "*.py" \) -exec chmod +x {} +
    fi
    total_skills=$((total_skills + 1))
    echo "  Skill → ${skill_dest}"
  fi
done

echo ""
echo "Installed: ${total_commands} commands, ${total_agents} agents, ${total_rules} rules, ${total_shell_scripts} shell scripts, ${total_skills} skills"
echo ""
echo "Commands (type / in Cursor chat):"
for f in "${TARGET}/commands/"*.md; do
  echo "  /$(basename "$f" .md)"
done
echo ""
echo "Agents available (auto-delegated by Task tool):"
for f in "${TARGET}/agents/"*.md; do
  echo "  $(basename "$f" .md)"
done
if [[ "${total_rules}" -gt 0 ]]; then
  echo ""
  echo "Rules (always-on in .cursor/rules/):"
  for f in "${TARGET}/rules/"*.mdc; do
    echo "  $(basename "$f")"
  done
fi
if [[ "${total_skills}" -gt 0 ]]; then
  echo ""
  echo "Skills (see ~/.cursor/skills/ or .cursor/skills/):"
  for d in "${TARGET}/skills/"*/; do
    [[ -d "$d" ]] || continue
    echo "  $(basename "$d")"
  done
fi
