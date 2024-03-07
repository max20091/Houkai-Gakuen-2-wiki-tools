@echo off
if not exist "%CD%\input\" mkdir %CD%\input\
if not exist "%CD%\output\" mkdir %CD%\output\
for %%f in ("%CD%\input\*.png") do cwebp -lossless -z 9 -mt -print_ssim "%%f" -o "%CD%\output\%%~nf.webp"
pause