@echo off
chcp 65001 > nul
cd /d "%~dp0"
title Penguin Magic
color 0B

echo.
echo  ============================================
echo       Penguin Magic - Starting...
echo  ============================================
echo.

:: Check Environment
echo  [CHECK] Verifying environment...

where python >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo  [ERROR] Python not found!
    echo          Please run "First Install.bat" or install Python
    echo.
    pause
    exit /b 1
)
echo  [OK] Python ready

where node >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo  [ERROR] Node.js not found!
    echo          Please run "First Install.bat" or install Node.js
    echo.
    pause
    exit /b 1
)
echo  [OK] Node.js ready

:: Check node_modules
if not exist "node_modules" (
    color 0E
    echo.
    echo  [WARN] Dependencies not installed, running npm install...
    echo.
    call npm install
    if %errorlevel% neq 0 (
        color 0C
        echo  [ERROR] npm install failed!
        pause
        exit /b 1
    )
)
echo  [OK] Dependencies ready
echo.

:: Kill existing services
echo  [CLEAN] Stopping old services...
for /f "tokens=5" %%a in ('netstat -ano 2^>nul ^| findstr ":8765 " ^| findstr "LISTENING"') do (
    taskkill /f /pid %%a >nul 2>&1
)
for /f "tokens=5" %%a in ('netstat -ano 2^>nul ^| findstr ":5176 " ^| findstr "LISTENING"') do (
    taskkill /f /pid %%a >nul 2>&1
)
echo  [OK] Ports cleared
echo.

:: Create directories
if not exist "data" mkdir "data"
if not exist "input" mkdir "input"
if not exist "output" mkdir "output"
if not exist "creative_images" mkdir "creative_images"

:: Start backend
echo  [1/2] Starting backend (Python)...
start "PenguinMagic-Backend" cmd /c "cd /d "%~dp0backend" && python server.py || (echo Backend failed && pause)"

:: Wait for backend
echo        Waiting for backend...
ping 127.0.0.1 -n 4 > nul

:: Check backend
netstat -ano | findstr ":8765" | findstr "LISTENING" >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo  [ERROR] Backend failed to start!
    echo          Check Python installation
    echo          Or check backend window for errors
    echo.
    pause
    exit /b 1
)
echo  [OK] Backend running (8765)
echo.

:: Start frontend
echo  [2/2] Starting frontend (Vite)...
start "PenguinMagic-Frontend" /min cmd /c "cd /d "%~dp0" && npm run dev"

:: Wait for frontend
echo        Waiting for frontend...
ping 127.0.0.1 -n 8 > nul

:: Check frontend
netstat -ano | findstr ":5176" | findstr "LISTENING" >nul 2>&1
if %errorlevel% neq 0 (
    color 0E
    echo  [WARN] Frontend may still be starting...
) else (
    echo  [OK] Frontend running (5176)
)

:: Open browser
echo.
color 0A
echo  [SUCCESS] Opening browser...
start http://localhost:5176

echo.
echo  ============================================
echo.
echo   Services running in background.
echo   You can close this window.
echo.
echo   Frontend: http://localhost:5176
echo   Backend:  http://localhost:8765
echo.
echo   To stop: run "stop-services.bat"
echo.
echo  ============================================
echo.

timeout /t 5 > nul
