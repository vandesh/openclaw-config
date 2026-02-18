# Requires PowerShell (run as Administrator)
# Creates a Scheduled Task that starts Moltbot on logon

$ConfigDir = $env:OPENCLAW_CONFIG_DIR
if (-not $ConfigDir) { $ConfigDir = "$env:USERPROFILE\openclaw-config" }
$EnvFile = $env:OPENCLAW_ENV_FILE
if (-not $EnvFile) { $EnvFile = "$ConfigDir\.env" }

if (-not (Test-Path $EnvFile)) {
  Write-Error "Env file not found: $EnvFile"
  exit 1
}

$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -Command `"`n$envPath = '$EnvFile';`nGet-Content $envPath | ForEach-Object { if ($_ -match '^(.*?)=(.*)$') { [Environment]::SetEnvironmentVariable($matches[1], $matches[2]) } };`nopenclaw gateway start`""
$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest

Register-ScheduledTask -TaskName "MoltbotGateway" -Action $Action -Trigger $Trigger -Principal $Principal -Force
Write-Host "Scheduled task created: MoltbotGateway"