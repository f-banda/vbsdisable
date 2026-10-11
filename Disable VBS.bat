@echo off
setlocal

set "SCRIPT_PATH=%~f0"
set "TOOL_DIR=%~dp0dgreadiness_v3.6"
set "ZIP_PATH=%~dp0dgreadiness_v3.6.zip"
set "DOWNLOAD_URL=https://download.microsoft.com/download/b/d/8/bd821b1f-05f2-4a7e-aa03-df6c4f687b07/dgreadiness_v3.6.zip"

:: Priv if !elevated
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell.exe -NoProfile -Command "Start-Process -FilePath $env:SCRIPT_PATH -Verb RunAs"
    exit /b
)

echo Checking DG Readiness Tool...
echo.

:: Download and extract
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference = 'Stop'; try { $tool = Get-ChildItem -LiteralPath $env:TOOL_DIR -Recurse -File -Filter 'DG_Readiness_Tool_v3.6.ps1' -ErrorAction SilentlyContinue | Select-Object -First 1; if (-not $tool) { Write-Host 'Downloading DG Readiness Tool...'; Invoke-WebRequest -Uri $env:DOWNLOAD_URL -OutFile $env:ZIP_PATH; if (Test-Path -LiteralPath $env:TOOL_DIR) { Remove-Item -LiteralPath $env:TOOL_DIR -Recurse -Force }; New-Item -ItemType Directory -Path $env:TOOL_DIR | Out-Null; Expand-Archive -LiteralPath $env:ZIP_PATH -DestinationPath $env:TOOL_DIR -Force; $tool = Get-ChildItem -LiteralPath $env:TOOL_DIR -Recurse -File -Filter 'DG_Readiness_Tool_v3.6.ps1' | Select-Object -First 1; if (-not $tool) { throw 'DG_Readiness_Tool_v3.6.ps1 was not found after extraction.' } }; Write-Host 'Running DG Readiness Tool...'; Set-Location -LiteralPath $tool.DirectoryName; & $tool.FullName -Disable; if ($LASTEXITCODE -ne 0 -and $null -ne $LASTEXITCODE) { exit $LASTEXITCODE } } catch { Write-Error $_; exit 1 }"

if errorlevel 1 (
    echo.
    echo ERROR: The DG Readiness Tool could not be downloaded, extracted, or ran...
    pause
    exit /b 1
)

echo.
echo DG Readiness Tool finished.
echo You can now restart your computer and confirm the changes.
echo.

timeout /t 5

endlocal