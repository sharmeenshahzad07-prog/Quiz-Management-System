# Kill any running Java processes
Get-Process java -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

# Start the server
Write-Host "Starting server..." -ForegroundColor Green
$serverProcess = Start-Process -FilePath java -ArgumentList "-cp","bin;libs/mysql-connector-j-8.0.33.jar","Main" -PassThru -WindowStyle Hidden
Start-Sleep -Seconds 4

# Test the quiz submission
Write-Host "`nTesting quiz submission..." -ForegroundColor Green
$payload = @{
    quizId = 1
    studentId = 8
    answers = @{
        question_1 = "A"
        question_2 = "B"
    }
} | ConvertTo-Json

Write-Host "Payload: $payload" -ForegroundColor Cyan

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/submit-quiz" `
        -Method POST `
        -ContentType "application/json" `
        -Body $payload `
        -TimeoutSec 10 `
        -ErrorAction SilentlyContinue
    
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Yellow
    Write-Host "Response: $($response.Content)" -ForegroundColor Yellow
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}

# Stop the server
Write-Host "`nStopping server..." -ForegroundColor Green
$serverProcess | Stop-Process -Force -ErrorAction SilentlyContinue
