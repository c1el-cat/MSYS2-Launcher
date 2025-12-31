# MSYS2探す
$msysRoot = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall |
    Get-ItemProperty |
    Where-Object { $_.Publisher -like "*The MSYS2 Developers*" -or $_.DisplayName -like "*MSYS2*" } |
    Select-Object -ExpandProperty InstallLocation -First 1

# フォールバック
if (-not $msysRoot -or -not (Test-Path $msysRoot)) {
    $commonPaths = @("C:\msys64", "D:\msys64", "$env:USERPROFILE\msys64")
    foreach ($path in $commonPaths) {
        if (Test-Path $path) { $msysRoot = $path; break }
    }
}

# 例外処理
if (-not $msysRoot -or -not (Test-Path (Join-Path $msysRoot "msys2_shell.cmd"))) {
    Write-Host "Error: MSYS2 not found. Please install MSYS2 or check your path." -ForegroundColor Red
    Pause
    exit
}

$msysShell = Join-Path $msysRoot "msys2_shell.cmd"

# オプションの定義
$options = @(
    @{ Name = "UCRT64";       Arg = "-ucrt64" },
    @{ Name = "MSYS";         Arg = "-msys" },
    @{ Name = "MINGW64";      Arg = "-mingw64" },
    @{ Name = "CLANGARM64";   Arg = "-clangarm64" },
    @{ Name = "CLANG64";      Arg = "-clang64" }
)

# 良さげなTUI

Write-Host "--- Choose MSYS2 edition to launch ---" -ForegroundColor Cyan
for ($i = 0; $i -lt $options.Count; $i++) {
    Write-Host ("[{0}] {1}" -f ($i + 1), $options[$i].Name)
}

# ユーザー入力
$choice = Read-Host "Select (Default is 1)"
if ($choice -eq "") { $index = 0 } else { 
    try {
        $index = [int]$choice - 1 
    } catch {
        $index = 0 # 例外処理
    }
}

# 範囲外チェック
if ($index -lt 0 -or $index -ge $options.Count) { $index = 0 }

$selected = $options[$index].Arg
Write-Host "Launching MSYS2 $selected from $msysRoot..." -ForegroundColor Green

# 起動
Start-Process "$msysShell" -ArgumentList "-defterm", "-no-start", $selected -Wait
