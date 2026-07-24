title Lumia Toolkit
@echo off
setlocal EnableDelayedExpansion

:: Define ESC variable for ANSI colors
for /f "tokens=1-2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"

set "thor2=C:\Program Files (x86)\Microsoft Care Suite\Windows Device Recovery Tool\thor2.exe"

:: Check if the executable exists
if not exist "%thor2%" (
    echo [ERROR] thor2.exe not found! Please check your WDRT installation path.
    echo Make sure Windows Device Recovery Tool is installed, if not, download, extract and install from:
    echo.
    echo https://archive.org/download/wdrt-hl1/wdrt-hl1.zip 	
    echo.
    echo Press any key to exit...
    <nul set /p="" & pause >nul
    exit /b
)

:: Caution
echo Make sure only ONE phone is connected!
echo.

:: Check device connection
echo [INFO] Trying to check if there is a phone connected...
echo.
"%thor2%" -mode list_connections
echo.
echo [INFO] The log above will show if any WP device is connected. If you see "Normal mode or Flash mode connected", your phone is connected.
echo If your phone in EDL Mode and come with offcial Qualcomm driver, it may not show here, but offcial driver are better, use it.
echo.
echo Press any key to continue...
<nul set /p="" & pause >nul

:: Main Menu Loop
:Menu
cls
call :Title
echo %ESC%[92mChoose an option below:%ESC%[0m
echo %ESC%[36m 1) %ESC%[97mPhone information %ESC%[90m(Requires rebooting to Flash Mode)%ESC%[0m
echo %ESC%[36m 2) %ESC%[97mUnbrick phone %ESC%[90m(EDL Only)%ESC%[0m
echo %ESC%[36m 3) %ESC%[97mFlashing firmware%ESC%[0m
echo %ESC%[36m 4) %ESC%[97mBoot mode%ESC%[0m
echo %ESC%[36m 5) %ESC%[97mSpoof device info %ESC%[90m(Requires rebooting to Mass storage mode)%ESC%[0m
echo %ESC%[36m X) %ESC%[97mExit%ESC%[0m
echo.
set "Opt="
set /p "Opt=%ESC%[92mOption:%ESC%[0m "
if not defined Opt goto Menu
set "Opt=%Opt:"=%"

if /i "%Opt%"=="1" goto PhoneInfo
if /i "%Opt%"=="2" goto SpecChoose
if /i "%Opt%"=="3" goto Option3
if /i "%Opt%"=="4" goto Option4
if /i "%Opt%"=="5" goto Option5
if /i "%Opt%"=="X" exit /b
goto Menu

:: Subroutines / Target Labels

:PhoneInfo
cls
echo [INFO] Reading phone info...
"%thor2%" -mode rnd -readdeviceinfo
echo.
echo [INFO] This is all of the phone information about partitions, IMEI, Root key hash, etc.
echo You can check it above now.
echo.
set "RebootOpt="
set /p "RebootOpt=Reboot phone now? (Y/N): "

if /i "%RebootOpt%"=="Y" (
    echo.
    echo [INFO] Rebooting phone...
    "%thor2%" -mode rnd -reboot
)

echo.
echo Press any key to return to menu...
<nul set /p="" & pause >nul
goto Menu

:SpecChoose
cls
call :Title
echo %ESC%[92mChoose your phone bootloader spec:%ESC%[0m
echo %ESC%[36m 1) %ESC%[97mSpec A %ESC%[90m(Lumia 520, 521, 525, 526, 620, 625, 720, 820, 822, 920, 925, 928, 1020, 1320)%ESC%[0m
echo %ESC%[36m 2) %ESC%[97mSpec B %ESC%[90m(Lumia 430, 435, 530, 532, 535, 540, 550, 630-638, 640/XL, 650, 730/735, 830, 929/930, 950/XL, 1520)%ESC%[0m
echo %ESC%[36m M) %ESC%[97mBack to Main Menu%ESC%[0m
echo.
set "SpecOpt="
set /p "SpecOpt=%ESC%[92mOption:%ESC%[0m "
if not defined SpecOpt goto SpecChoose
set "SpecOpt=%SpecOpt:"=%"

if /i "%SpecOpt%"=="1" goto SpecA
if /i "%SpecOpt%"=="2" goto SpecB
if /i "%SpecOpt%"=="M" goto Menu
goto SpecChoose

:SpecA
cls
call :Title
echo %ESC%[92m--- UNBRICK SPEC A DEVICE ---%ESC%[0m
echo %ESC%[90mEnsure your phone is in Emergency Mode / Qualcomm HS-USB QDLoader 9008%ESC%[0m
echo.

:: 1. Chọn file FFU
set "FFU_PATH="
set /p "FFU_PATH=%ESC%[36m[1/3] Enter path to FFU file (.ffu): %ESC%[0m"
if not defined FFU_PATH goto SpecA
:: Làm sạch ngoặc kép thừa (nếu có)
set "FFU_PATH=%FFU_PATH:"=%"
if not exist "%FFU_PATH%" (
    echo %ESC%[91m[ERROR] FFU file not found! Please check the path.%ESC%[0m
    echo.
    echo Press any key to try again...
    <nul set /p="" & pause >nul
    goto SpecA
)

:: 2. Chọn file MBN
:GetMBN
echo.
set "MBN_PATH="
set /p "MBN_PATH=%ESC%[36m[2/3] Enter path to MBN file (.mbn / HEX/MBN package): %ESC%[0m"
if not defined MBN_PATH goto GetMBN
set "MBN_PATH=%MBN_PATH:"=%"
if not exist "%MBN_PATH%" (
    echo %ESC%[91m[ERROR] MBN file not found! Please check the path.%ESC%[0m
    echo.
    echo Press any key to try again...
    goto GetMBN
)

:: 3. Chọn file HEX
:GetHEX
echo.
set "HEX_PATH="
set /p "HEX_PATH=%ESC%[36m[3/3] Enter path to HEX file (.hex): %ESC%[0m"
if not defined HEX_PATH goto GetHEX
set "HEX_PATH=%HEX_PATH:"=%"
if not exist "%HEX_PATH%" (
    echo %ESC%[91m[ERROR] HEX file not found! Please check the path.%ESC%[0m
    echo.
    echo Press any key to try again...
    goto GetHEX
)

:: Thực thi lệnh Unbrick với Thor2
cls
call :Title
echo %ESC%[93m[INFO] Starting Spec A emergency flashing procedure...%ESC%[0m
echo.
echo FFU: "%FFU_PATH%"
echo MBN: "%MBN_PATH%"
echo HEX: "%HEX_PATH%"
echo.

"%thor2%" -mode emergency -mbnfile "%MBN_PATH%" -hexfile "%HEX_PATH%" -ffufile "%FFU_PATH%"
"%thor2%" -mode rnd -bootnormalmode

echo.
echo %ESC%[92mProcedure finished!%ESC%[0m
echo Press any key to return to menu...
<nul set /p="" & pause >nul
goto Menu


:SpecB
cls
call :Title
echo %ESC%[92m--- UNBRICK SPEC B DEVICE ---%ESC%[0m
echo %ESC%[90mEnsure your phone is in Emergency Mode / Qualcomm HS-USB QDLoader 9008%ESC%[0m
echo.

:: 1. Chọn file FFU
set "FFU_PATH="
set /p "FFU_PATH=%ESC%[36m[1/3] Enter path to FFU file (.ffu): %ESC%[0m"
if not defined FFU_PATH goto SpecB
set "FFU_PATH=%FFU_PATH:"=%"
if not exist "%FFU_PATH%" (
    echo %ESC%[91m[ERROR] FFU file not found! Please check the path.%ESC%[0m
    echo.
    echo Press any key to try again...
    <nul set /p="" & pause >nul
    goto SpecB
)

:: 2. Chọn file EDE
:GetEDE
echo.
set "EDE_PATH="
set /p "EDE_PATH=%ESC%[36m[2/3] Enter path to EDE file (.ede): %ESC%[0m"
if not defined EDE_PATH goto GetEDE
set "EDE_PATH=%EDE_PATH:"=%"
if not exist "%EDE_PATH%" (
    echo %ESC%[91m[ERROR] EDE file not found! Please check the path.%ESC%[0m
    echo.
    echo Press any key to try again...
    goto GetEDE
)

:: 3. Chọn file EDP
:GetEDP
echo.
set "EDP_PATH="
set /p "EDP_PATH=%ESC%[36m[3/3] Enter path to EDP file (.edp): %ESC%[0m"
if not defined EDP_PATH goto GetEDP
set "EDP_PATH=%EDP_PATH:"=%"
if not exist "%EDP_PATH%" (
    echo %ESC%[91m[ERROR] EDP file not found! Please check the path.%ESC%[0m
    echo.
    echo Press any key to try again...
    goto GetEDP
)

:: Thực thi lệnh Unbrick cho Spec B với Thor2
cls
call :Title
echo %ESC%[93m[INFO] Starting Spec B emergency flashing procedure...%ESC%[0m
echo.
echo FFU: "%FFU_PATH%"
echo EDE: "%EDE_PATH%"
echo EDP: "%EDP_PATH%"
echo.

"%thor2%" -mode emergency -hexfile "%EDE_PATH%" -edfile "%EDP_PATH%" -ffufile "%FFU_PATH%"
"%thor2%" -mode rnd -bootnormalmode

echo.
echo %ESC%[92mProcedure finished!%ESC%[0m
echo Press any key to return to menu...
<nul set /p="" & pause >nul
goto Menu

:Option3
cls
call :Title
echo %ESC%[92m--- DIRECT FFU FLASHING ---%ESC%[0m
echo %ESC%[90mEnsure your phone is in Flash Mode (Nokia Logo / Two points Screen)%ESC%[0m
cd /D "%~dp0"
flashmodedemo.jpg
echo %ESC%[91mALL DATA WILL BE ERASED!%ESC%[0m
echo.

set "FFU_PATH="
set /p "FFU_PATH=%ESC%[36mEnter path to FFU file (.ffu): %ESC%[0m"
if not defined FFU_PATH goto Menu
set "FFU_PATH=%FFU_PATH:"=%"
if not exist "%FFU_PATH%" (
    echo %ESC%[91m[ERROR] FFU file not found! Please check the path.%ESC%[0m
    echo.
    echo Press any key to try again...
    <nul set /p="" & pause >nul
    goto Option3
)

cls
call :Title
echo %ESC%[93m[INFO] Starting FFU flashing procedure...%ESC%[0m
echo File: %FFU_PATH%
echo.

"%thor2%" -mode uefiflash -ffufile "%FFU_PATH%" -do_full_nvi_update -do_factory_reset -reboot
"%thor2%" -mode rnd -bootnormalmode

echo.
echo %ESC%[92mFFU Flashing completed!%ESC%[0m
echo Press any key to return to Main Menu...
<nul set /p="" & pause >nul
goto Menu

:Option4
cls
call :Title
echo %ESC%[92m--- DEVICE REBOOT / MODE SWITCHER ---%ESC%[0m
echo %ESC%[90mSelect the mode you want to reboot your phone into:%ESC%[0m
echo.
echo %ESC%[36m 1) %ESC%[97mNormal Reboot %ESC%[90m(Boot into OS)%ESC%[0m
echo %ESC%[36m 2) %ESC%[97mReboot to Flash Mode %ESC%[90m(For FFU flashing / Device info)%ESC%[0m
echo %ESC%[36m 3) %ESC%[97mReboot to Emergency / EDL Mode %ESC%[90m(Qualcomm 9008 - For Unbricking)%ESC%[0m
echo %ESC%[36m 4) %ESC%[97mReboot to Mass Storage Mode %ESC%[90m(Only unlocked bootloader)%ESC%[0m
echo %ESC%[36m M) %ESC%[97mBack to Main Menu%ESC%[0m
echo.
set "RebootCmd="
set /p "RebootCmd=%ESC%[92mOption:%ESC%[0m "
if not defined RebootCmd goto Option4
set "RebootCmd=%RebootCmd:"=%"

if /i "%RebootCmd%"=="1" (
    echo.
    echo %ESC%[93m[INFO] Rebooting phone to Normal OS Mode...%ESC%[0m
    "%thor2%" -mode rnd -bootnormalmode
) else if /i "%RebootCmd%"=="2" (
    echo.
    echo %ESC%[93m[INFO] Rebooting phone to Flash Mode...%ESC%[0m
    "%thor2%" -mode rnd -bootflashapp
) else if /i "%RebootCmd%"=="3" (
    echo.
    echo %ESC%[93m[INFO] Forcing phone into Emergency / EDL Mode...%ESC%[0m
    "%thor2%" -mode rnd -boot_edmode
) else if /i "%RebootCmd%"=="4" (
    echo.
    echo %ESC%[93m[INFO] Rebooting phone to Mass Storage Mode...%ESC%[0m
    "%thor2%" -mode rnd -bootmsc
) else if /i "%RebootCmd%"=="M" (
    goto Menu
) else (
    goto Option4
)

echo.
echo %ESC%[92mCommand sent successfully!%ESC%[0m
echo Press any key to return to Main Menu...
<nul set /p="" & pause >nul
goto Menu
:Option5
cls
print :Title
NSudo\NSudoC.exe -U:T -P:E spoof.cmd
echo Press any key to return to Main Menu...
<nul set /p="" & pause >nul
goto Menu

:: Header Banner Subroutine
:Title
echo  _____                 .__         ___________            .__   __   .__  __   
echo  ^|    ^|    __ __  _____ ^|__^|____    \__    ___/___   ____ ^|  ^| ^|  ^| _^|__^|/  ^|_ 
echo  ^|    ^|   ^|  ^|  \/     \^|  \__  \     ^|    ^| /  _ \ /  _ \^|  ^| ^|  ^|/ /  ^|\   __\
echo  ^|    ^|___^|  ^|  /  Y Y  \  ^|/ __ \_   ^|    ^|(  ^<_^> ^|  ^<_^> )  ^|_^|    ^<^|  ^|^|  ^|  
echo  ^|_______ \____/^|__^|_^|  /__^(____  /   ^|____^| \____/ \____/^|____/__^|_ \__^|^|__^|  
echo          \/           \/        \/                               \/          
echo.
exit /b