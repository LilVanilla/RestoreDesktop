# RestoreDesktop
Save and Restore Desktop Icons with the click of a button

TO INSTALL: 

Download and run install.bat, admin permissions are only neccessary if you would like to add to the desktop context menu

TO USE: 

You can either manually run the DesktopSave and DesktopRestore programs in the folder manually, or use the context menu options.



Don't want to download the installer? Here is the code for the two programs:

DesktopSave.bat:

REG EXPORT HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Bags\1\Desktop C:\Users\USERNAME\Documents\RestoreDesktop\Desktopsave.txt /y 

DesktopRestore.bat:

Taskkill /IM "explorer.exe" /F 

REG IMPORT C:\Users\USERNAME\Documents\RestoreDesktop\Desktopsave.txt

start explorer.exe

