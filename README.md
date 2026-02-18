# 🚀 Moltbot Config — Cosmic Edition

A clean, portable setup that keeps **secrets off GitHub** while making it easy to move Moltbot to any server.

✅ Syncs Moltbot config to a Git repo with a **single setup**

✅ Creates a service to **auto‑start** Moltbot

✅ Creates and auto‑runs a **config sync watcher** (Linux)

✅ Works across **Linux / macOS / Windows**

---

## 🗂️ What’s in this repo?

- **`openclaw.json`** → tracked config with `${VAR}` placeholders (no secrets)
- **`.env`** → **not tracked**, holds secrets on your machine
- **`.env.example`** → template for new servers (fill `OPENCLAW_WORKSPACE` too)

### 🧩 Scripts (what they do)

- **`apply-config.sh`** → loads `.env`, applies config, restarts gateway
- **`apply-from-repo.sh`** → applies repo config to server + restarts gateway
- **`install-service.sh`** → Linux systemd gateway service (openclaw)
- **`install-service-macos.sh`** → macOS launchd gateway service (openclaw)
- **`install-service-windows.ps1`** → Windows Scheduled Task (openclaw)
- **`install-config-sync.sh`** → Linux user service to auto‑commit config changes
- **`sync-config.sh`** → sanitizes secrets → commits updated config
- **`install-config-sync-autopush.sh`** → Linux auto‑commit **and push**
- **`install-config-sync-autopush-macos.sh`** → macOS auto‑commit **and push**
- **`install-config-sync-autopush-windows.ps1`** → Windows auto‑commit **and push**
- **`sync-config-push.sh`** → sync + push (requires git creds)
- **`stellar-setup.sh`** → one‑shot “new server” setup (auto‑detects OS)
- **`smoke-test.sh`** → dry‑run checks (no system changes)

---

# 🧭 Setup

# 🌌 One‑shot setup (recommended)

> Works on Linux/macOS. On Windows, run the PowerShell script.
> **Does NOT enable linger.** See IMPORTANT below.

### 🐧 Linux / 🍎 macOS

```bash
bash stellar-setup.sh
```

### 🪟 Windows (PowerShell Admin)

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\install-service-windows.ps1
```

---

# ✅ Step‑by‑step setup (open‑source flow)

Assume you already know Git. Fork/clone first, then follow these steps.

## 1) Clone your repo

```bash
git clone <YOUR_GIT_URL> ~/openclaw-config
cd ~/openclaw-config
```

## 2) Add secrets locally (not in Git)

```bash
cp .env.example .env
# edit .env and fill secrets
```

## 3) Apply config

```bash
bash apply-config.sh
```

## 4) Install auto‑start service

### 🐧 Linux (systemd)

```bash
sudo bash install-service.sh
```

### 🍎 macOS (launchd)

```bash
bash install-service-macos.sh
```

### 🪟 Windows (Scheduled Task)

```powershell
# Run PowerShell as Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force
.\install-service-windows.ps1
```

---

# ✨ Additional features

## 🔁 Auto‑sync config → Git (auto‑commit, no push)

### Linux only

```bash
bash install-config-sync.sh
# Optional: keep user services running after logout
sudo loginctl enable-linger $USER
```

Manual restart (if needed):

```bash
systemctl --user restart openclaw-config-sync.path
```

---

## 🚀 Auto‑sync + auto‑push
Requires git credentials configured for push.

### Linux
```bash
bash install-config-sync-autopush.sh
```
Manual restart:
```bash
systemctl --user restart openclaw-config-sync-push.path
```

### macOS
```bash
bash install-config-sync-autopush-macos.sh
```

### Windows (PowerShell Admin)
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\install-config-sync-autopush-windows.ps1
```

---

## 🧩 Apply repo config to server (single script)
```bash
bash apply-from-repo.sh
```
This copies `openclaw.json` from the repo into `~/.openclaw/` and restarts the gateway.

---

## 🌍 First push to GitHub

```bash
cd ~/openclaw-config
git remote add origin <YOUR_GIT_URL>
git push -u origin main
```

---

## 🧪 Quick sanity check

Run the dry‑run smoke test:
```bash
bash smoke-test.sh
```

- `.env` **never** goes into Git (gitignored)
- `openclaw.json` uses **`${VAR}` placeholders**
- Gateway restarts cleanly

---

## ⚠️ IMPORTANT: Linger (Linux only)
Linger keeps your **user systemd services running after logout**. Without it, the auto‑sync watcher runs only while you’re logged in.

**Not included** in the One‑shot setup on purpose.

### Enable (Linux)
```bash
bash enable-linger.sh
```

### macOS / Windows
Not applicable.

---

If anything feels off, feel free to open a PR, or report, or better yet - use your own Moltbot ❤️ to fix and PR 🛰️
