@echo off
REM ===== Quiz Management System - Run Script =====
REM This script compiles and runs the Quiz API Server

setlocal enabledelayedexpansion

echo ===== Quiz Management System =====
echo.

REM Check if Java is installed
java -version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Java is not installed or not in PATH
    echo Please install Java and add it to your system PATH
    pause
    exit /b 1
)

REM Navigate to project directory
cd /d "%~dp0"

echo Step 1: Compiling Java files...
if not exist "bin" mkdir bin

javac -d bin -cp "libs/mysql-connector-j-8.0.33.jar" src/*.java

if errorlevel 1 (
    echo.
    echo ERROR: Compilation failed!
    echo Please check the errors above.
    pause
    exit /b 1
)

echo Compilation successful!
echo.
echo Step 2: Starting Quiz API Server...
echo Server will start on http://localhost:8080
echo.
echo Press Ctrl+C to stop the server
echo.

REM Start the server from project root so static files under web/ are served correctly
java -cp "bin;libs\mysql-connector-j-8.0.33.jar" QuizAPIServer

pause
