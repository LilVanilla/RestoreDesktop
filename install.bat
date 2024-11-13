@echo off
NET FILE > NUL 2>&1 || POWERSHELL -ex Unrestricted -Command "Start-Process -Verb RunAs -FilePath '%ComSpec%' -ArgumentList '/c \"%~fnx0\" %*'" && EXIT /b

echo -----Install Directory-----
set installDirectory=C:\Users\%USERNAME%\Documents\RestoreDesktop\
set /p isDefaultOk=Install to Default Directory %installDirectory%? (Y/n):
REM --If Default location is ok, skip custom folder selection--
if "%isDefaultOk%" == "y" (goto DefaultFolder)
if "%isDefaultOk%" == "Y" (goto DefaultFolder)
if "%isDefaultOk%" == "" (goto DefaultFolder)
setlocal

set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Please choose a folder, the RestoreDesktop application folder will be created inside.',0,0).self.path""

for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

setlocal enabledelayedexpansion
endlocal
set installDirectory=%folder%\RestoreDesktop\

:DefaultFolder
echo Directory set to %installDirectory%

REM --Make Files in Set Directory--
mkdir %installDirectory%
echo Taskkill /IM "explorer.exe" /F >%installDirectory%DesktopRestore.bat
echo REG IMPORT %installDirectory%Desktopsave.txt>>%installDirectory%DesktopRestore.bat
echo start explorer.exe>>%installDirectory%DesktopRestore.bat
echo REG EXPORT HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Bags\1\Desktop %installDirectory%Desktopsave.txt /y >%installDirectory%DesktopSave.bat
echo Successfully Installed
echo -----Additional Options-----
echo Would you like to add RestoreDesktop to the Desktop Context Menu? (Right Click on Desktop)
echo 1) Only Restore
echo 2) Save and Restore
echo 3) Do not add
set /p addContext= Option:
REM --Add context menu entries--
if "%addContext%" == "1" (REG add "HKLM\SOFTWARE\Classes\DesktopBackground\Shell\Restore Desktop\command" /t REG_SZ /d %installDirectory%DesktopRestore.bat)
if "%addContext%" == "2" (REG add "HKLM\SOFTWARE\Classes\DesktopBackground\Shell\Save Desktop\command" /t REG_SZ /d %installDirectory%DesktopSave.bat)
if "%addContext%" == "2" (REG add "HKLM\SOFTWARE\Classes\DesktopBackground\Shell\Restore Desktop\command" /t REG_SZ /d %installDirectory%DesktopRestore.bat)
echo Setup Complete!
pause
