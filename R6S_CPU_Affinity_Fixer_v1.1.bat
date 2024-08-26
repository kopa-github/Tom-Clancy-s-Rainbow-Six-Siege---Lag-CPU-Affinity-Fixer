@echo off
cls

REM v1.1


SET AFFINITY_CPU0=1
SET AFFINITY_ALL=F
SET VULKAN=False
SET DIRECTX=False
SET PID=
SET ALL_AFFINITY=0
SET NUM_CPUS=0



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
    goto RetryAPI
)	



:RetryAPI
cls
echo Tom Clancy's Rainbow Six Siege - Affinity Fix:
echo.
echo.
echo.
echo.
echo Select the game's API:
echo ---------------------------------
echo 1. DirectX 11 (Default)
echo 2. Vulkan
echo.
echo 0. Exit
echo.
echo.
set /p choice=Select (1, 2 or 0): 


if "%choice%"=="1" (
    SET PROGRAM_NAME=RainbowSix.exe
	echo.
	echo.
	echo -----------------
    echo API: DirectX 11
	echo -----------------
	echo.
	timeout /t 1 >nul 2>&1
	SET DIRECTX=True
    goto ErrorCheck
) else if "%choice%"=="2" (
    SET PROGRAM_NAME=RainbowSix_Vulkan.exe
	echo.
	echo.
	echo -------------
    echo API: Vulkan
	echo -------------
	echo.
	timeout /t 1 >nul 2>&1
	SET VULKAN=True
    goto ErrorCheck
) else if "%choice%"=="0" (
    cls
	echo Tom Clancy's Rainbow Six Siege - Affinity Fix:
	echo.
	echo.
	echo.
    echo Happy gaming!
	echo.
	timeout /t 1 >nul 2>&1
    exit /b
) else (
	cls
	echo Tom Clancy's Rainbow Six Siege - Affinity Fix:
	echo.
	echo.
	echo.
	echo.
	echo Error:
	echo.
	echo.	
    echo Please select the correct API.
	echo Use 1, 2 or 0.
	echo.
	echo.
	echo.
	pause
    goto RetryAPI
)



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
if "%VULKAN%"=="True" (
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
	pause
	SET VULKAN=False
	goto RetryAPI
	) else if "%DIRECTX%"=="True" (
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
		SET DIRECTX=False
		goto RetryAPI
	)
)
set PID=%%i
goto SuccessfulPID



:SuccessfulPID
echo.
echo Applying the fix for %PROGRAM_NAME%:
echo -------------------------------------------
echo.
echo Setting %PROGRAM_NAME%'s Affinity to CPU 0


REM Setting Affinity to CPU (0)
powershell -Command "& { $process = Get-Process -Id %PID%; $process.ProcessorAffinity = 1 }"
timeout /t 1 >nul 2>&1


echo Done.
echo.
echo Setting back %PROGRAM_NAME%'s Affinity to all CPUs
timeout /t 1 >nul 2>&1


REM Checking Core Count and Masking
for /f "usebackq" %%a in (`powershell -Command "& { (Get-WmiObject Win32_Processor).NumberOfLogicalProcessors }"`) do set NUM_CPUS=%%a
set /a "ALL_AFFINITY=(2 ** %NUM_CPUS%) - 1"


REM Setting Back Affinity
powershell -Command "& { $process = Get-Process -Id %PID%; $process.ProcessorAffinity = 0x%ALL_AFFINITY% }"


echo Done.
timeout /t 1 >nul 2>&1
echo.
echo.
echo.
echo.
echo Fix applied successfully. You can return back to the game.
echo Happy gaming!
echo.
echo.
timeout /t 1
