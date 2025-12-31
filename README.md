# MSYS2-Launcher
A simple MSYS2 launcher for Windows Terminal.
I'm not criticizing MSYS2, but doesn't it have too many unnecessary options that make it confusing? - I agree.

So, I created a PowerShell script that makes it super easy to select WSYS2 startup options from Windows Terminal (wt.exe).

Here is a sample.
<img width="1770" height="964" alt="image" src="https://github.com/user-attachments/assets/b8d90f6f-8e1d-43ec-afa4-6209328abc77" />

## How to install
I created a simple PowerShell script that can be easily installed.

Please run the following command in PowerShell.
It's **pwsh**. It's not cmd.

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; irm https://github.com/c1el-cat/MSYS2-Launcher/raw/refs/heads/main/install.ps1 | iex
```

<img width="885" height="482" alt="image" src="https://github.com/user-attachments/assets/1ce59b79-2fd5-4ad1-a5d4-7814f3bb12b7" />

This installer might have been harder to make than the main program itself.
