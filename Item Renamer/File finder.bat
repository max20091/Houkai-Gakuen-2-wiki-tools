@echo off
if not exist "%CD%\allequipmentfigures\" echo allequipmentfigures not found
if not exist "%CD%\allequipmenticons\" echo allequipmenticons not found
echo Enter file ID with keyboard.
set /P fileID=Enter file ID:
copy "%CD%\allequipmentfigures\%fileID%.png" "%CD%\%fileID% figure.png"
copy "%CD%\allequipmenticons\%fileID%.png" "%CD%\%fileID% icon.png"
set /a fileID=fileID + 1
copy "%CD%\allequipmentfigures\%fileID%.png" "%CD%\%fileID% figure.png"
copy "%CD%\allequipmenticons\%fileID%.png" "%CD%\%fileID% icon.png"
pause