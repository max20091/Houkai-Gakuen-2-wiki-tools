@echo off
echo Compress PNG
if not exist "%CD%\file\" mkdir "%CD%\file\"
oxipng -o max -Z --zi 255 --strip safe -r "%CD%\file"
pause
exit