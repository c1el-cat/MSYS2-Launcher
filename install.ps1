# TLS1.2を強制（バグ防止）
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# MSYS2の場所をレジストリから探す
$msysRoot = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall |
    Get-ItemProperty |
    Where-Object { $_.Publisher -like "*The MSYS2 Developers*" -or $_.DisplayName -like "*MSYS2*" } |
    Select-Object -ExpandProperty InstallLocation -First 1

    # 見つかんなかったときのフォールバック
    if (-not $msysRoot) {
        if (Test-Path "C:\msys64") { $msysRoot = "C:\msys64" }
        Write-Host "The fallback path is being used because MSYS2 could not be found.
Please replace it with the correct path later in the wt configuration." -ForegroundColor Yellow
    }

# インストール先の指定
$destDir = "$HOME\.msys2"
if (-not (Test-Path $destDir)) { 
    New-Item -ItemType Directory -Path $destDir -Force
}

# パスを指定
$remoteUrl = "https://github.com/c1el-cat/MSYS2-Launcher/raw/refs/heads/main/msys2-select.ps1"
$localPath = Join-Path $destDir "msys2-select.ps1"
$cmd = 'powershell.exe -ExecutionPolicy Bypass -File "%USERPROFILE%\.msys2\msys2-select.ps1"'
$ico = Join-Path $HOME ".msys2\msys2.ico"

# アイコン周りの処理
$sourceIcon = Join-Path $msysRoot "msys2.ico"
$destIcon = Join-Path $destDir "msys2.ico"

if (Test-Path $sourceIcon) {
    Copy-Item -Path $sourceIcon -Destination $destIcon -Force
    Write-Host "Icon copied to $destIcon" -ForegroundColor Green
} else {
    Write-Host "Warning: Source icon not found at $sourceIcon" -ForegroundColor Yellow
}

# DL
Write-Host "Downloading msys2-select.ps1 from GitHub..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $remoteUrl -OutFile $localPath -ErrorAction Stop
    Write-Host "Successfully downloaded to $localPath" -ForegroundColor Green
} catch {
    Write-Error "Failed to download the script. Check the URL or your internet connection."
    exit
}

# wtのconfigを探す旅
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (-not (Test-Path $settingsPath)) {
    $settingsPath = "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
}

$settings = Get-Content $settingsPath | ConvertFrom-Json

# プロファイル重複チェック
if (-not ($settings.profiles.list | Where-Object { $_.name -eq "MSYS2 Launcher" })) {

    # プロファイルを作る
    $newProfile = [PSCustomObject]@{
    name              = "MSYS2 Launcher"
    commandline       = $cmd
    icon              = $ico
    startingDirectory = "%USERPROFILE%"
}

    $settings.profiles.list += $newProfile
    
    $settings | ConvertTo-Json -Depth 100 | Set-Content $settingsPath -Encoding UTF8
    Write-Host "Successfully added the MSYS Launcher to Windows Terminal." -ForegroundColor Green
}

Write-Host "Done! Please restart Windows Terminal." -ForegroundColor Green