# ===== Quiz Management System - Run Script =====
# This script compiles and runs the Quiz API Server

Write-Host "===== Quiz Management System =====" -ForegroundColor Cyan
Write-Host ""

# Check if Java is installed
try {
    $javaVersion = java -version 2>&1
    Write-Host "Java found: $($javaVersion[0])" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Java is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Java and add it to your system PATH" -ForegroundColor Red
    exit 1
}

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $projectRoot

Write-Host ""
Write-Host "Step 1: Compiling Java files..." -ForegroundColor Cyan

if (-not (Test-Path "bin")) {
    New-Item -ItemType Directory -Name "bin" | Out-Null
}

$compileCmd = "javac -d bin -cp `"libs/mysql-connector-j-8.0.33.jar`" src/*.java"
Invoke-Expression $compileCmd

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: Compilation failed!" -ForegroundColor Red
    Write-Host "Please check the errors above." -ForegroundColor Red
    exit 1
}

Write-Host "Compilation successful!" -ForegroundColor Green
Write-Host ""
Write-Host "Step 2: Starting Quiz API Server..." -ForegroundColor Cyan
Write-Host "Server will start on http://localhost:8080" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Start the server
Set-Location bin
& java -cp ".;..\libs\mysql-connector-j-8.0.33.jar" QuizAPIServer

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: Failed to start server" -ForegroundColor Red
    Write-Host "Make sure MySQL is running and database credentials are correct" -ForegroundColor Red
}
