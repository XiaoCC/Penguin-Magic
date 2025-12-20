@echo off
chcp 65001 > nul
cd /d "%~dp0"

echo.
echo  Penguin Magic - Stop Services
echo.

:: Stop backend
echo  Stopping backend (port 8765)...
for /f "tokens=5" %%a in ('netstat -ano 2^>nul ^| findstr ":8765 " ^| findstr "LISTENING"') do (
    taskkill /f /pid %%a >nul 2>&1
    echo  [OK] Killed PID: %%a
)

:: Stop frontend
echo  Stopping frontend (port 5176)...
for /f "tokens=5" %%a in ('netstat -ano 2^>nul ^| findstr ":5176 " ^| findstr "LISTENING"') do (
    taskkill /f /pid %%a >nul 2>&1
    echo  [OK] Killed PID: %%a
)

:: Close related cmd windows
taskkill /f /fi "WINDOWTITLE eq PenguinMagic-Backend" >nul 2>&1
taskkill /f /fi "WINDOWTITLE eq PenguinMagic-Frontend" >nul 2>&1

echo.
echo  [OK] All services stopped!
echo.
timeout /t 3 > nul
