#!/usr/bin/env bash
set -euo pipefail

# Apply repo config to local Clawdbot/Moltbot config and restart gateway
CONFIG_DIR="${OPENCLAW_CONFIG_DIR:-$HOME/openclaw-config}"
TARGET_CONFIG_DIR="${OPENCLAW_TARGET_CONFIG_DIR:-$HOME/.openclaw}"

cd "$CONFIG_DIR"

cp ./openclaw.json "$TARGET_CONFIG_DIR/openclaw.json"

# Restart gateway
openclaw gateway restart

echo "Applied repo config to $TARGET_CONFIG_DIR/openclaw.json and restarted gateway."