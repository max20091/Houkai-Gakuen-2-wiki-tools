::set /p stig=stig
::echo %~n1
@echo off
if exist "%CD%\2 3 pocket\" goto :RENAME
if not exist "%CD%\1 1 item\" mkdir "%CD%\1 1 item\"
if not exist "%CD%\1 2 icon\" mkdir "%CD%\1 2 icon\"
if not exist "%CD%\1 3 pocket\" mkdir "%CD%\1 3 pocket\"
if not exist "%CD%\2 1 item\" mkdir "%CD%\2 1 item\"
if not exist "%CD%\2 2 icon\" mkdir "%CD%\2 2 icon\"
if not exist "%CD%\2 3 pocket\" mkdir "%CD%\2 3 pocket\"
:RENAME
echo Enter file name with keyboard.
set /P file=Enter item name:
set /P star=Enter number of stars:
IF %star% LSS 2 FOR %%f in ("%CD%\1 1 item\*.png") DO REN "%CD%\1 1 item\*.png" "%file% %star% Star.png"
IF %star% GEQ 2 FOR %%f in ("%CD%\1 1 item\*.png") DO REN "%CD%\1 1 item\*.png" "%file% %star% Stars.png"
IF %star% LSS 2 FOR %%f in ("%CD%\1 2 icon\*.png") DO REN "%CD%\1 2 icon\*.png" "%file% %star% Star icon.png"
IF %star% GEQ 2 FOR %%f in ("%CD%\1 2 icon\*.png") DO REN "%CD%\1 2 icon\*.png" "%file% %star% Stars icon.png"
IF %star% LSS 2 FOR %%f in ("%CD%\1 3 pocket\*.png") DO REN "%CD%\1 3 pocket\*.png" "%file% %star% Star pocket.png"
IF %star% GEQ 2 FOR %%f in ("%CD%\1 3 pocket\*.png") DO REN "%CD%\1 3 pocket\*.png" "%file% %star% Stars pocket.png"
FOR %%f in ("%CD%\1 1 item\*.png") DO MOVE "%CD%\1 1 item\*.png" "%CD%\"
FOR %%f in ("%CD%\1 2 icon\*.png") DO MOVE "%CD%\1 2 icon\*.png" "%CD%\"
FOR %%f in ("%CD%\1 3 pocket\*.png") DO MOVE "%CD%\1 3 pocket\*.png" "%CD%\"
set /a star=star + 1
FOR %%f in ("%CD%\2 1 item\*.png") DO REN "%CD%\2 1 item\*.png" "%file% %star% Stars.png"
FOR %%f in ("%CD%\2 2 icon\*.png") DO REN "%CD%\2 2 icon\*.png" "%file% %star% Stars icon.png"
FOR %%f in ("%CD%\2 3 pocket\*.png") DO REN "%CD%\2 3 pocket\*.png" "%file% %star% Stars pocket.png"
FOR %%f in ("%CD%\2 1 item\*.png") DO MOVE "%CD%\2 1 item\*.png" "%CD%\"
FOR %%f in ("%CD%\2 2 icon\*.png") DO MOVE "%CD%\2 2 icon\*.png" "%CD%\"
FOR %%f in ("%CD%\2 3 pocket\*.png") DO MOVE "%CD%\2 3 pocket\*.png" "%CD%\"
exit
