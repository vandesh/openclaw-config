# Requires PowerShell (run as Administrator)
# Creates a Scheduled Task that auto-syncs and auto-pushes config

$ConfigDir = $env:OPENCLAW_CONFIG_DIR
if (-not $ConfigDir) { $ConfigDir = "$env:USERPROFILE\openclaw-config" }
$Script = "$ConfigDir\sync-config-push.sh"

$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -Command `"`nbash '$Script'`""
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 5) -RepetitionDuration ([TimeSpan]::MaxValue)
$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest

Register-ScheduledTask -TaskName "MoltbotConfigSyncPush" -Action $Action -Trigger $Trigger -Principal $Principal -Force
Write-Host "Scheduled task created: MoltbotConfigSyncPush (runs every 5 minutes)"