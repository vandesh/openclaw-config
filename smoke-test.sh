#!/usr/bin/env bash
set -euo pipefail

# Dry-run smoke test (no changes to system)

CONFIG_DIR="${MOLTBOT_CONFIG_DIR:-$HOME/moltbot-config}"
ENV_FILE="${MOLTBOT_ENV_FILE:-$CONFIG_DIR/.env}"

cd "$CONFIG_DIR"

echo "[1/5] Repo files present"
for f in clawdbot.json .env.example apply-config.sh install-service.sh install-service-macos.sh install-service-windows.ps1 install-config-sync.sh stellar-setup.sh sync-config.sh; do
  [[ -f "$f" ]] || { echo "Missing $f"; exit 1; }
done

if [[ -f "$ENV_FILE" ]]; then
  echo "[2/5] .env present (local)"
else
  echo "[2/5] .env missing (ok if not set up yet)"
fi

echo "[3/5] No secrets hardcoded in repo"
if grep -RIn "sk-\|AIza\|DEEPGRAM_API_KEY=.*[^$]" . --exclude-dir=.git --exclude=.env; then
  echo "Potential secret detected" >&2
  exit 1
fi

echo "[4/5] Moltbot command usage in scripts"
if grep -RIn "clawdbot gateway" .; then
  echo "Found clawdbot command usage" >&2
  exit 1
fi

echo "[5/5] Paths use ~/.clawdbot/clawdbot.json (expected per docs)"
if ! grep -RIn "\.clawdbot/clawdbot\.json" .; then
  echo "Expected config path not found" >&2
  exit 1
fi

echo "Smoke test OK"