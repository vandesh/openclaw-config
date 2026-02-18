#!/usr/bin/env bash
set -euo pipefail

if ! command -v systemctl >/dev/null 2>&1; then
  echo "systemctl not found. This script is for Linux systemd only." >&2
  exit 1
fi

SERVICE_PATH="/etc/systemd/system/openclaw.service"
USER_NAME="${SUDO_USER:-$(id -un)}"
USER_HOME="$(getent passwd "$USER_NAME" | cut -d: -f6)"
CONFIG_DIR="${OPENCLAW_CONFIG_DIR:-$USER_HOME/openclaw-config}"
ENV_FILE="${OPENCLAW_ENV_FILE:-$CONFIG_DIR/.env}"

if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (sudo)." >&2
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Env file not found: $ENV_FILE" >&2
  exit 1
fi

cat > "$SERVICE_PATH" <<EOF
[Unit]
Description=Clawdbot Gateway
After=network.target

[Service]
Type=simple
User=$USER_NAME
WorkingDirectory=$USER_HOME
EnvironmentFile=$ENV_FILE
ExecStart=/usr/bin/env bash -lc 'openclaw gateway start'
ExecStop=/usr/bin/env bash -lc 'openclaw gateway stop'
Restart=on-failure
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

echo "Wrote $SERVICE_PATH"

systemctl daemon-reload
systemctl enable --now openclaw
systemctl status openclaw --no-pager
