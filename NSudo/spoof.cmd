@echo off
chcp 65001 >nul
title Device Info Spoofer (TrustedInstaller)
cd /d "%~dp0"

:: Định nghĩa mã màu ANSI
for /f "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"

:SpoofMenu
cls
echo %ESC%[92m===================================================%ESC%[0m
echo %ESC%[92m        LUMIA DEVICE INFO SPOOFER TOOL            %ESC%[0m
echo %ESC%[92m===================================================%ESC%[0m
echo.
echo %ESC%[36m 1) %ESC%[97mMount MainOS Registry Hive (SYSTEM)%ESC%[0m
echo %ESC%[36m 2) %ESC%[97mSelect Target Device Model to Spoof%ESC%[0m
echo %ESC%[36m 3) %ESC%[97mUnload Registry Hive ^& Exit%ESC%[0m
echo.

:: Kiểm tra trạng thái Registry Hive
reg query "HKLM\RTSYSTEM" >nul 2>&1
if %errorlevel% equ 0 (
    echo %ESC%[92m[STATUS] RTSYSTEM Hive is currently MOUNTED.%ESC%[0m
) else (
    echo %ESC%[91m[STATUS] RTSYSTEM Hive is NOT mounted yet.%ESC%[0m
)
echo.

set "Option="
set /p "Option=%ESC%[92mSelect an option [1-3]: %ESC%[0m"
if not defined Option goto SpoofMenu
set "Option=%Option:"=%"

if "%Option%"=="1" goto MountHive
if "%Option%"=="2" goto SelectDevice
if "%Option%"=="3" goto UnloadAndExit
goto SpoofMenu


:MountHive
cls
echo %ESC%[92m--- MOUNT MAINOS REGISTRY HIVE ---%ESC%[0m
echo.
reg query "HKLM\RTSYSTEM" >nul 2>&1
if %errorlevel% equ 0 (
    echo %ESC%[93m[INFO] RTSYSTEM Hive is already mounted!%ESC%[0m
    echo Press any key to return to menu...
    pause >nul
    goto SpoofMenu
)

set "DriveLetter="
set /p "DriveLetter=%ESC%[36mEnter MainOS partition drive letter (e.g., E, F, G): %ESC%[0m"
if not defined DriveLetter goto MountHive
set "DriveLetter=%DriveLetter:"=%"
set "DriveLetter=%DriveLetter::=%"

if not exist "%DriveLetter%:\Windows\System32\config\SYSTEM" (
    echo.
    echo %ESC%[91m[ERROR] Unable to locate SYSTEM registry file at %DriveLetter%:\Windows\System32\config\%ESC%[0m
    echo Please make sure you entered the correct drive letter!
    echo.
    echo Press any key to try again...
    pause >nul
    goto MountHive
)

echo.
echo %ESC%[93m[INFO] Loading SYSTEM hive to HKLM\RTSYSTEM...%ESC%[0m
reg load "HKLM\RTSYSTEM" "%DriveLetter%:\Windows\System32\config\SYSTEM"

if %errorlevel% equ 0 (
    echo %ESC%[92m[SUCCESS] SYSTEM Hive successfully loaded as RTSYSTEM!%ESC%[0m
) else (
    echo %ESC%[91m[ERROR] Failed to load registry hive!%ESC%[0m
)
echo Press any key to continue...
pause >nul
goto SpoofMenu


:SelectDevice
cls
echo %ESC%[92m--- SELECT DEVICE MODEL TO SPOOF ---%ESC%[0m
echo.

reg query "HKLM\RTSYSTEM" >nul 2>&1
if %errorlevel% neq 0 (
    echo %ESC%[91m[ERROR] RTSYSTEM Hive is not mounted! Please select Option 1 first.%ESC%[0m
    echo.
    echo Press any key to return...
    pause >nul
    goto SpoofMenu
)

echo %ESC%[36m 1) %ESC%[97mLumia 550%ESC%[0m
echo %ESC%[36m 2) %ESC%[97mLumia 640%ESC%[0m
echo %ESC%[36m 3) %ESC%[97mLumia 950 XL %ESC%[90m(Are you ready for the lag?)%ESC%[0m
echo %ESC%[36m B) %ESC%[97mBack to Spoofer Menu%ESC%[0m
echo.

set "DevChoice="
set /p "DevChoice=%ESC%[92mSelect device profile: %ESC%[0m"
if not defined DevChoice goto SelectDevice
set "DevChoice=%DevChoice:"=%"

if /i "%DevChoice%"=="1" goto SpoofL550
if /i "%DevChoice%"=="2" goto SpoofL640
if /i "%DevChoice%"=="3" goto SpoofL950XL
if /i "%DevChoice%"=="B" goto SpoofMenu
goto SelectDevice


:SpoofL550
echo.
echo %ESC%[93m[INFO] Writing Lumia 550 parameters to Registry...%ESC%[0m
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneHardwareVariant" /t REG_SZ /d "RM-1127" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneManufacturer" /t REG_SZ /d "MicrosoftMDG" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneManufacturerModelName" /t REG_SZ /d "RM-1127_13771" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneMobileOperatorName" /t REG_SZ /d "000-88" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneModelName" /t REG_SZ /d "Lumia 550" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneSOCVersion" /t REG_SZ /d "8909" /f
goto SpoofDone


:SpoofL640
echo.
echo %ESC%[93m[INFO] Writing Lumia 640 parameters to Registry...%ESC%[0m
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneHardwareVariant" /t REG_SZ /d "RM-1073" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneManufacturer" /t REG_SZ /d "MicrosoftMDG" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneManufacturerModelName" /t REG_SZ /d "RM-1073_1004" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneMobileOperatorName" /t REG_SZ /d "000-IT" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneModelName" /t REG_SZ /d "Lumia 640" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneMobileOperatorDisplayName" /t REG_SZ /d "CV IT" /f
goto SpoofDone


:SpoofL950XL
echo.
echo %ESC%[93m[INFO] Writing Lumia 950 XL parameters to Registry...%ESC%[0m
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneHardwareVariant" /t REG_SZ /d "RM-1085" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneManufacturer" /t REG_SZ /d "MicrosoftMDG" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneManufacturerModelName" /t REG_SZ /d "RM-1085_12584" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneMobileOperatorName" /t REG_SZ /d "000-VN" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneModelName" /t REG_SZ /d "Lumia 950 XL" /f
reg add "HKLM\RTSYSTEM\Platform\DeviceTargetingInfo" /v "PhoneSOCVersion" /t REG_SZ /d "8994" /f
goto SpoofDone


:SpoofDone
echo.
echo %ESC%[92m[SUCCESS] Device info spoofed successfully!%ESC%[0m
echo Press any key to return to menu...
pause >nul
goto SpoofMenu


:UnloadAndExit
cls
echo %ESC%[93m[INFO] Cleaning up Registry Hives...%ESC%[0m
reg query "HKLM\RTSYSTEM" >nul 2>&1
if %errorlevel% equ 0 (
    echo %ESC%[90mUnloading HKLM\RTSYSTEM...%ESC%[0m
    reg unload "HKLM\RTSYSTEM" >nul 2>&1
    if %errorlevel% equ 0 (
        echo %ESC%[92m[SUCCESS] Registry hive unloaded cleanly.%ESC%[0m
    ) else (
        echo %ESC%[91m[WARNING] Failed to unload RTSYSTEM. Make sure Regedit or other processes are closed.%ESC%[0m
    )
) else (
    echo %ESC%[90mNo mounted hive detected.%ESC%[0m
)

echo.
echo Press any key to exit and return to Lumia Toolkit...
pause >nul
cmd /c exit