@echo off
setlocal enabledelayedexpansion
if not exist "%CD%\allequipmentfigures\" echo allequipmentfigures not found
if not exist "%CD%\allequipmenticons\" echo allequipmenticons not found
echo Enter file ID with keyboard.
set /P fileID=Enter file ID:
copy "%CD%\allequipmentfigures\%fileID%.png" "%CD%\1 1 item\%fileID% figure.png"
copy "%CD%\allequipmenticons\%fileID%.png" "%CD%\1 2 icon\%fileID% icon.png"
set /a fileID=fileID + 1
copy "%CD%\allequipmentfigures\%fileID%.png" "%CD%\2 1 item\%fileID% figure.png"
copy "%CD%\allequipmenticons\%fileID%.png" "%CD%\2 2 icon\%fileID% icon.png"
pause