#!/usr/bin/env bash
set -euo pipefail

# Linux systemd --user auto-sync setup

if ! command -v systemctl >/dev/null 2>&1; then
  echo "systemctl not found. This script is for Linux systemd only." >&2
  exit 1
fi

CONFIG_DIR="${OPENCLAW_CONFIG_DIR:-$HOME/openclaw-config}"
USER_SYSTEMD_DIR="$HOME/.config/systemd/user"

mkdir -p "$USER_SYSTEMD_DIR"
cp "$CONFIG_DIR/systemd-user/openclaw-config-sync.service" "$USER_SYSTEMD_DIR/"
cp "$CONFIG_DIR/systemd-user/openclaw-config-sync.path" "$USER_SYSTEMD_DIR/"

systemctl --user daemon-reload
systemctl --user enable --now openclaw-config-sync.path

echo "Auto-sync enabled (user systemd path)."
echo "Optional: keep user services running after logout:"
echo "  sudo loginctl enable-linger $USER"
