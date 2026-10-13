# Creates a Windows scheduled task that runs zxterm-start.sh in WSL on login
$action = New-ScheduledTaskAction -Execute "wsl" -Argument "-e bash $env:USERPROFILE\zxterm\zxterm-start.sh"
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName "ZxtermAutoStart" -Action $action -Trigger $trigger -Settings $settings -Force
Write-Host "Auto-start installed — Zxterm will start when you log into Windows"