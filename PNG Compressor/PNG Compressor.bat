@echo off
setlocal enabledelayedexpansion
echo Compress PNG
if not exist "%CD%\file\" mkdir "%CD%\file\"
oxipng -o max --strip safe -r "%CD%\file"
pause
exit