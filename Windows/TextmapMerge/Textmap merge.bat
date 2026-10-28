@echo off
@setlocal enabledelayedexpansion
if not exist "%CD%\input\" mkdir %CD%\input\
for %%f in ("%CD%\input\*.txt") do type "%%f" >> output.txt
pause