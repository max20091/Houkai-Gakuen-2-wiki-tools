@echo off
setlocal enabledelayedexpansion
if not exist "%CD%\input\" mkdir "%CD%\input\"
if not exist "%CD%\output\" mkdir "%CD%\output\"
for %%f in ("%CD%\Input\*1 Star icon.png") do Magick convert -composite -gravity center "%CD%\Backgrounds\Green.png" "%%f" "%CD%\Output\%%~nf.png"
for %%f in ("%CD%\Input\*2 Stars icon.png") do Magick convert -composite -gravity center "%CD%\Backgrounds\Green.png" "%%f" "%CD%\Output\%%~nf.png"
for %%f in ("%CD%\Input\*3 Stars icon.png") do Magick convert -composite -gravity center "%CD%\Backgrounds\Blue.png" "%%f" "%CD%\Output\%%~nf.png"
for %%f in ("%CD%\Input\*4 Stars icon.png") do Magick convert -composite -gravity center "%CD%\Backgrounds\Blue.png" "%%f" "%CD%\Output\%%~nf.png"
for %%f in ("%CD%\Input\*5 Stars icon.png") do Magick convert -composite -gravity center "%CD%\Backgrounds\Purple.png" "%%f" "%CD%\Output\%%~nf.png"
for %%f in ("%CD%\Input\*6 Stars icon.png") do Magick convert -composite -gravity center "%CD%\Backgrounds\Purple.png" "%%f" "%CD%\Output\%%~nf.png"
for %%f in ("%CD%\Input\*7 Stars icon.png") do Magick convert -composite -gravity center "%CD%\Backgrounds\Gold.png" "%%f" "%CD%\Output\%%~nf.png"