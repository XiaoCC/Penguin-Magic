@echo off
chcp 65001 > nul
title Penguin Magic - First Install
cd /d "%~dp0"
color 0B

echo.
echo  ============================================
echo       Penguin Magic - First Time Setup
echo  ============================================
echo.

:: Check Environment
echo  [1/3] Checking environment...
echo.

where python >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo  [ERROR] Python not found!
    echo.
    echo  Please install Python 3.10 or higher:
    echo  Download: https://www.python.org/downloads/
    echo.
    echo  Check "Add Python to PATH" during installation
    echo.
    pause
    exit /b 1
)

for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VER=%%i
echo  [OK] Python %PYTHON_VER%

where node >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo  [ERROR] Node.js not found!
    echo.
    echo  Please install Node.js 18 or higher:
    echo  Download: https://nodejs.org/
    echo.
    pause
    exit /b 1
)

for /f "tokens=1" %%i in ('node --version 2^>^&1') do set NODE_VER=%%i
echo  [OK] Node.js %NODE_VER%
echo.

:: Install Dependencies
echo  [2/3] Installing dependencies (npm install)...
echo        This may take a few minutes...
echo.

call npm install
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo  [ERROR] npm install failed!
    echo          Please check network connection
    pause
    exit /b 1
)

echo.
echo  [OK] Dependencies installed
echo.

:: Create Directories
echo  [3/3] Creating data directories...

if not exist "data" mkdir "data"
if not exist "input" mkdir "input"
if not exist "output" mkdir "output"
if not exist "creative_images" mkdir "creative_images"

echo  [OK] Directories created
echo.

:: Done
color 0A
echo.
echo  ============================================
echo.
echo       Installation Complete!
echo.
echo   You can now run the application:
echo   Double-click "Start.bat" to launch
echo.
echo  ============================================
echo.
pause
