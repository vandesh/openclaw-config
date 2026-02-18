#!/usr/bin/env bash
set -euo pipefail

# macOS launchd user agent
PLIST_PATH="$HOME/Library/LaunchAgents/com.openclaw.gateway.plist"
CONFIG_DIR="${OPENCLAW_CONFIG_DIR:-$HOME/openclaw-config}"
ENV_FILE="${OPENCLAW_ENV_FILE:-$CONFIG_DIR/.env}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Env file not found: $ENV_FILE" >&2
  exit 1
fi

cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.openclaw.gateway</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>-lc</string>
    <string>set -a; source "$ENV_FILE"; set +a; openclaw gateway start</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>$HOME/Library/Logs/openclaw-gateway.log</string>
  <key>StandardErrorPath</key>
  <string>$HOME/Library/Logs/openclaw-gateway.err</string>
</dict>
</plist>
EOF

launchctl unload "$PLIST_PATH" >/dev/null 2>&1 || true
launchctl load "$PLIST_PATH"
launchctl start com.openclaw.gateway

echo "Loaded launchd agent: $PLIST_PATH"