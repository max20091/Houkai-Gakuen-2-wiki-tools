::set /p stig=stig
::echo %~n1
@echo off
echo Compress PNG
if not exist "%CD%\file\" mkdir "%CD%\file\"
FOR %%f in ("%CD%\file\*.png") DO oxipng.exe -o max -Z --strip safe "%%f"
pause
exit