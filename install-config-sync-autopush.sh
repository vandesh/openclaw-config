#!/usr/bin/env bash
set -euo pipefail

# Linux systemd --user auto-sync + auto-push setup

if ! command -v systemctl >/dev/null 2>&1; then
  echo "systemctl not found. This script is for Linux systemd only." >&2
  exit 1
fi

CONFIG_DIR="${OPENCLAW_CONFIG_DIR:-$HOME/openclaw-config}"
USER_SYSTEMD_DIR="$HOME/.config/systemd/user"

mkdir -p "$USER_SYSTEMD_DIR"
cp "$CONFIG_DIR/systemd-user/openclaw-config-sync-push.service" "$USER_SYSTEMD_DIR/"
cp "$CONFIG_DIR/systemd-user/openclaw-config-sync-push.path" "$USER_SYSTEMD_DIR/"

systemctl --user daemon-reload
systemctl --user enable --now openclaw-config-sync-push.path

echo "Auto-sync + auto-push enabled (user systemd path)."
echo "Requires git credentials configured for push."