@echo off
setlocal enabledelayedexpansion
if not exist "%CD%\input\" mkdir %CD%\input\
if not exist "%CD%\output\" mkdir %CD%\output\
if not exist "%CD%\alpha\" mkdir %CD%\alpha\
for %%f in ("%CD%\input\*.png") do magick "%%f" -alpha extract "%CD%\alpha\%%~nf.png"
pause