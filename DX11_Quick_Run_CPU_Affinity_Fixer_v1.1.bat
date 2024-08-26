@echo off
cls

REM v1.1


SET AFFINITY_CPU0=1
SET AFFINITY_ALL=F
SET PID=
SET ALL_AFFINITY=0
SET NUM_CPUS=0



REM This is for DirectX 11 API
SET PROGRAM_NAME=RainbowSix.exe



:AdminRights
net session >nul 2>&1
if %errorlevel% neq 0 (
	echo Tom Clancy's Rainbow Six Siege - Affinity Fix:
	echo.
	echo.
	echo.
	echo.
    echo It is recommended to run this as Administrator.
	echo.
	timeout /t 2
    goto WarningAPI
)	




:WarningAPI
cls
echo Tom Clancy's Rainbow Six Siege - Affinity Fix:
echo.
echo.
echo.
echo -----------------
echo API: DirectX 11
echo -----------------
echo.
goto ErrorCheck



:ErrorCheck
echo.

for /f "tokens=2 delims==" %%i in ('wmic process where "name='%PROGRAM_NAME%'" get ProcessID /value 2^>^&1') do (
    if "%%i"=="No Instance(s) Available." (
		goto ErrorFoundPID
    ) else (
        set PID=%%i
		goto SuccessfulPID
    )
)

REM Done by your's truly, kopa.


:ErrorFoundPID
cls
echo Tom Clancy's Rainbow Six Siege - Affinity Fix:
echo.
echo.
echo.
echo.
echo DirectX 11 API not detected.
echo.
echo Make sure %PROGRAM_NAME% is already running.
echo.
echo.
echo.
pause
exit /b 1



:SuccessfulPID
echo.
echo Applying the fix for %PROGRAM_NAME%:
echo -------------------------------------------
echo.
echo Executing commands...


REM Setting Affinity to CPU (0)
powershell -Command "& { $process = Get-Process -Id %PID%; $process.ProcessorAffinity = 1 }"
timeout /t 1 >nul 2>&1


REM Checking Core Count and Masking
for /f "usebackq" %%a in (`powershell -Command "& { (Get-WmiObject Win32_Processor).NumberOfLogicalProcessors }"`) do set NUM_CPUS=%%a
set /a "ALL_AFFINITY=(2 ** %NUM_CPUS%) - 1"


REM Setting Back Affinity
powershell -Command "& { $process = Get-Process -Id %PID%; $process.ProcessorAffinity = 0x%ALL_AFFINITY% }"


echo.
echo.
echo Done.
echo.
echo.
echo.
echo Fix applied successfully. You can return back to the game.
echo Happy gaming!
timeout /t 1 >nul 2>&1
