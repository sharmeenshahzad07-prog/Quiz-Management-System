@echo off
REM Kill any existing Java processes
taskkill /F /IM java.exe >nul 2>&1
timeout /t 2

REM Change to the demo directory
cd /d "C:\Users\waqar\Music\Final_DSA_Project\connectedDB\Project1.2\demo"

REM Start the server in a hidden window
echo Starting API Server...
start /B javaw -cp "bin;libs/mysql-connector-j-8.0.33.jar" APIServer

REM Wait for server to start
timeout /t 5

REM Test the quiz submission endpoint
echo Testing Quiz Submission...
powershell -NoProfile -Command ^
  "$payload = ConvertTo-Json @{quizId=1; studentId=8; answers=@{question_1='A'; question_2='B'}}; "^
  "$r = Invoke-WebRequest 'http://localhost:8080/api/submit-quiz' -Method POST -Body $payload -ContentType 'application/json' -ErrorAction SilentlyContinue; "^
  "Write-Host \"Status: $($r.StatusCode)\"; "^
  "Write-Host \"Response: $($r.Content)\""

REM Clean up
echo.
echo Stopping server...
taskkill /F /IM javaw.exe >nul 2>&1
echo Done!
