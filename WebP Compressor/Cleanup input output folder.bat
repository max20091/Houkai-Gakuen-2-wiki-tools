@echo off
echo Cleanup input and output folder
FOR %%f in ("%CD%\input\*.png") DO DEL "%CD%\input\*.png"
FOR %%f in ("%CD%\output\*.webp") DO DEL "%CD%\output\*.webp"
exit
