#!/usr/bin/env bash
set -euo pipefail

# Master setup script for a new server
# - Apply config
# - Install gateway service (OS-aware)
# - Install auto-sync watcher (Linux only)

CONFIG_DIR="${OPENCLAW_CONFIG_DIR:-$HOME/openclaw-config}"
ENV_FILE="${OPENCLAW_ENV_FILE:-$CONFIG_DIR/.env}"
OS="$(uname -s)"

if [[ ! -d "$CONFIG_DIR" ]]; then
  echo "Config dir not found: $CONFIG_DIR" >&2
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Env file not found: $ENV_FILE" >&2
  echo "Copy .env.example to .env and fill in secrets first." >&2
  exit 1
fi

cd "$CONFIG_DIR"

# Apply config
bash apply-config.sh

# Install gateway service (OS-aware)
case "$OS" in
  Linux*)
    if command -v systemctl >/dev/null 2>&1; then
      if command -v sudo >/dev/null 2>&1; then
        sudo bash install-service.sh
      else
        echo "sudo not found; please run: sudo bash install-service.sh" >&2
      fi
    else
      echo "systemctl not found; skip install-service.sh on Linux." >&2
    fi
    ;;
  Darwin*)
    bash install-service-macos.sh
    ;;
  MINGW*|MSYS*|CYGWIN*)
    echo "Windows detected. Run PowerShell as Administrator and execute:" >&2
    echo "  .\\install-service-windows.ps1" >&2
    ;;
  *)
    echo "Unknown OS: $OS" >&2
    ;;
esac

# Install auto-sync watcher (Linux only)
if [[ "$OS" == "Linux"* ]] && command -v systemctl >/dev/null 2>&1; then
  bash install-config-sync.sh
else
  echo "Auto-sync watcher supported on Linux only." >&2
fi

echo "Stellar setup complete."