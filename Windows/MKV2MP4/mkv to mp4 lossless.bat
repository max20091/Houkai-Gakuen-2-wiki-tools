@echo off
setlocal enabledelayedexpansion
for %%f IN (*.mkv) DO ffmpeg -i "%%f" -c copy "%%~nf.mp4"