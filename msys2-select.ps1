$options = @(
    @{ Name = "UCRT64";       Arg = "-ucrt64" },
    @{ Name = "MSYS";         Arg = "-msys" },
    @{ Name = "MINGW64";      Arg = "-mingw64" },
    @{ Name = "CLANGARM64";   Arg = "-clangarm64" },
    @{ Name = "CLANG64";      Arg = "-clang64" }
)

Write-Host "--- Choose MSYS2 edition to launch ---" -ForegroundColor Cyan
for ($i = 0; $i -lt $options.Count; $i++) {
    Write-Host ("[{0}] {1}" -f ($i + 1), $options[$i].Name)
}

$choice = Read-Host "Select (Default is 1)"
if ($choice -eq "") { $index = 0 } else { $index = [int]$choice - 1 }

$selected = $options[$index].Arg
Write-Host "Launching MSYS2 $selected..." -ForegroundColor Green

Start-Process "C:\msys64\msys2_shell.cmd" -ArgumentList "-defterm", "-no-start", $selected -Wait