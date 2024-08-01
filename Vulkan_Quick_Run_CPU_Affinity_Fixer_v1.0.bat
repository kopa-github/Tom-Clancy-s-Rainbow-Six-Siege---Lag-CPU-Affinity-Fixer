@echo off
cls


SET AFFINITY_CPU0=1
SET AFFINITY_ALL=F
SET PID=


REM This is for Vulkan API
SET PROGRAM_NAME=RainbowSix_Vulkan.exe



:AdminRights
net session >nul 2>&1
if %errorlevel% neq 0 (
	cls
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
echo -------------
echo API: Vulkan
echo -------------
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
echo Vulkan API not detected.
echo.
echo Make sure %PROGRAM_NAME% is already running.
echo.
echo.
echo.
timeout /t 3
exit /b 1



:SuccessfulPID
echo.
echo Applying the fix for %PROGRAM_NAME%:
echo -------------------------------------------
echo.
echo Executing commands...
powershell -Command "& { $process = Get-Process -Id %PID%; $process.ProcessorAffinity = 0x%AFFINITY_CPU0% }"
timeout /t 1 >nul 2>&1
powershell -Command "& { $process = Get-Process -Id %PID%; $process.ProcessorAffinity = 0x%AFFINITY_ALL% }"
echo.
echo.
echo Done.
echo.
echo.
echo.
echo Fix applied successfully. You can return back to the game.
echo Happy gaming!
timeout /t 1 >nul 2>&1