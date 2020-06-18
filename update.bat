@echo off

:start
title "tiphergane multi tool updater"
REM init des variables
set mt=update
set get=.\Data\wget.exe
set rar=.\Data\unrar.exe
set sed=.\Data\sed.exe
set test=.\Data\test.exe

REM Menu
cls
echo.
echo ********************************************************************************
echo       			bienvenue dans le batch d'update du multitool
echo.                          
echo ********************************************************************************
echo.
echo 1: Update
echo 2: Quitter 
echo Faite Votre Choix: [1,2]?
set /p choix=
if %choix%==1 goto update
if %choix%==2 goto exit

:update
if exist %mt%.txt del %mt%.txt
%get% http://tiphergane.free.fr/DESIRE/%mt%.txt 1>sf_diag.tmp 2>&1
%sed% -n "/ERROR 404/p" sf_diag.tmp > sf_404.tmp
REM "ERROR 404" is english text; we have no gettext support in wget 1.12.1-devel so this is ok for now.

%test% -s sf_404.tmp
if errorlevel 0 if not errorlevel 1 (
	del sf_404.tmp 1>NUL 2>&1
	echo
	echo Error: No update found on server ( Error 404 ^).
	goto exit
)
for /F %%i in (%mt%.txt) do set res=%%i
for /F %%i in (.\Data\update\%mt%.txt) do set rev=%%i
echo la version sur les serveur est: %res%
echo la version sur ton pc est : %rev%


if %res%==%rev% (
	echo Il n'y a pas d'update a faire
	ping -n 6 localhost > nul
	goto exit
)


if not %res%==%rev% (
	echo Update présente, on lance le process
	echo %res% > .\Data\update\%mt%.txt
	ping -n 6 localhost > nul
	goto nop
)

:nop
echo
echo Telechargement de l'update %mt%%res%.rar
set up="http://tiphergane.free.fr/DESIRE/update/%mt%%res%.rar" 1>NUL 2>&1
echo "dedut de la mise a jour"
%get% %up% 1> NUL 2>&1
%rar% x -y %mt%%res%.rar
goto exit

:exit
ping -n 6 localhost > nul
if exist %mt%.txt del %mt%.txt
if exist %mt%%res%.rar del %mt%%res%.rar
if exist *.tmp del *.tmp
REM fin du batch
