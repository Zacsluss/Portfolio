@echo off
echo ========================================
echo   Zachary Sluss Portfolio - Local Server
echo ========================================
echo.

:: Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed or not in PATH.
    echo Trying Python 3...
    python3 --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo Python 3 is also not found.
        echo Please install Python from https://www.python.org/
        pause
        exit /b 1
    ) else (
        set PYTHON_CMD=python3
    )
) else (
    set PYTHON_CMD=python
)

:: Function to find an available port
:: Start from 8080 to avoid common development ports
set PORT=8080
set MAX_PORT=9999

:FINDPORT
echo Checking port %PORT%...

:: Use netstat to check if port is in use (more reliable)
netstat -an | findstr ":%PORT% " | findstr "LISTENING" >nul 2>&1

if %errorlevel% equ 0 (
    echo Port %PORT% is in use, trying next port...
    set /a PORT+=1
    if %PORT% gtr %MAX_PORT% (
        echo No available ports found between 8080-%MAX_PORT%
        echo.
        echo Hint: You may have other servers running. Try closing them first.
        pause
        exit /b 1
    )
    goto FINDPORT
)

echo.
echo Found available port: %PORT%
echo Starting local server...
echo.
echo ========================================
echo Server will run at: http://localhost:%PORT%
echo Press Ctrl+C in this window to stop the server
echo ========================================
echo.

:: Start Chrome in incognito mode after a short delay
start /b cmd /c "timeout /t 2 >nul && start chrome.exe --incognito http://localhost:%PORT%"

:: Start Python HTTP server with the found port
%PYTHON_CMD% -m http.server %PORT%

:: This will execute after Ctrl+C is pressed
echo.
echo Server stopped.
pause