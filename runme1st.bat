@echo off
REM /
REM | HTC DESIRE MULTITOOL by tiphergane
REM | © tiphergane for the batch
REM | All rights of the app used in this batch go to their owners
REM | This bat was built with notepad++ and lot of cofee
REM | He's free (you can make a donation to tiphergane by paypal)
REM | and he CAN'T BE USE FOR COMMERCIAL USE.
REM | 
REM | This batch was built in 2010 for helping the DESIRE's owner
REM | to do some manipulation found on XDA's website.
REM | All the exploit used here are from the XDA's forum
REM | 
REM | This work was under creative commons, you can used it for build your own
REM | you can share it if you send the ORGINAL HTC-DEV's link
REM | You can help us to improve the multitool, with a GUI or everything that can help
REM | users to used it less complicated
REM |
REM | Greets go to (in random order)
REM | XDA's members who build the application used here
REM | HTC-DEV's members and testers who help me to improve it
REM | All the generous donators who helps me to keep strong
REM | My coffee maker and my coffee dealer
REM | My wife for her patience while I'm coding this tool
REM | You all the multitool's user (the world first one)
REM | Thank you all !!!
REM | 
REM | End Of Transmition
REM \

:start
title "tiphergane multi tool for HTC DESIRE"
REM init des variables
set mt=multitool
set adb=.\Data\adb.exe

REM Menu
cls
echo.
echo ********************************************************************************
echo       bienvenue dans le batch multiservice de tiphergane pour le HTC DESIRE
echo                            Windows Version checker
echo ********************************************************************************
echo.
echo 1: Creation du multitool pour ton GSM
echo 2: Quitter 
echo Faite Votre Choix: [1,2]?
set /p choix=
if %choix%==1 goto ver
if %choix%==2 goto exit

:ver
if exist .\MMC\MID.txt del .\MMC\MID.txt
cls
echo.
echo ********************************************************************************
echo       bienvenue dans le batch multiservice de tiphergane pour le HTC DESIRE
echo                            Windows Version checker
echo ********************************************************************************
echo.
echo Merci de brancher votre GSM en mode "charge seule" et "debogage USB"
REM Lancement du daemon adb
%adb% kill-server
%adb% start-server > nul
%adb% shell getprop ro.serialno > .\Data\sn.txt
%adb% shell getprop gsm.operator.alpha > .\Data\op.txt
for /F %%a in (.\Data\sn.txt) do echo Serial Number: %%a
for /F %%b in (.\Data\op.txt) do echo Operateur Actuel: %%b
echo creation du multitool en cours .....
del .\Data\sn.txt
del .\Data\op.txt
REM attente d'un GSM
REM recupération du type hardware avec ADB et écriture dans le fichier MID.txt
%adb% shell getprop ro.product.device > .\MMC\MID.txt
REM copie du MID trouvé dans la variable mid
for /F %%i in (.\MMC\MID.txt) do set mid=%%i
REM recherche du mid précédement trouvé dans la liste des MID supporté
findstr %mid% .\Data\MID.txt
REM si mid connu, alors création du multitool pour l'OS et le GSM
if %errorlevel%==0 goto %mid% > nul
REM si MID inconnu, alors BADBOY
echo ton MID (%mid%) est pas pris en charge par le multitool
echo ce multitool est fait pour les HTC BRAVO/ACE/VISION
ping -n 5 localhost > nul
goto exit


:bravo
for /F "tokens=5 delims=] " %%v in ('ver') do set version=%%v
if %version%.==. for /F "tokens=4 delims=] " %%v in ('ver') do set version=%%v
if %version%==5.00.2195 goto W2k
if %version%==5.1.2600 goto W2k
if %version%==5.2.3790 goto W2k
if %version%==6.0.6000 goto Vista
if %version%==6.1.7600 goto Vista
if %version%==6.1.7601 goto Vista

:W2k
if exist %mt%.* del %mt%.*
copy .\tool\WINDOWS\"%mt% XP.bat" %mt%.bat
echo DONE !
del .\MMC\MID.txt
ping -n 6 localhost > nul
goto exit

:Vista
if exist %mt%.* del %mt%.*
copy .\tool\WINDOWS\"%mt%.bat" %mt%.bat
echo DONE !
ping -n 6 localhost > nul
del .\MMC\MID.txt
goto exit

:ace
for /F "tokens=5 delims=] " %%v in ('ver') do set version=%%v
if %version%.==. for /F "tokens=4 delims=] " %%v in ('ver') do set version=%%v
if %version%==5.00.2195 goto W2kHD
if %version%==5.1.2600 goto W2kHD
if %version%==5.2.3790 goto W2kHD
if %version%==6.0.6000 goto VistaHD
if %version%==6.1.7600 goto VistaHD
if %version%==6.1.7601 goto VistaHD

:W2kHD
if exist %mt%.* del %mt%.*
copy .\tool\WINDOWS\"%mt% DHD XP.bat" %mt%.bat
echo DONE !
ping -n 6 localhost > nul
del .\MMC\MID.txt
goto exit

:VistaHD
if exist %mt%.* del %mt%.*
copy .\tool\WINDOWS\"%mt% DHD.bat" %mt%.bat
echo DONE !
ping -n 6 localhost > nul
del .\MMC\MID.txt
goto exit

:vision
for /F "tokens=5 delims=] " %%v in ('ver') do set version=%%v
if %version%.==. for /F "tokens=4 delims=] " %%v in ('ver') do set version=%%v
if %version%==5.00.2195 goto W2kZ
if %version%==5.1.2600 goto W2kZ
if %version%==5.2.3790 goto W2kZ
if %version%==6.0.6000 goto VistaZ
if %version%==6.1.7600 goto VistaZ
if %version%==6.1.7600 goto VistaZ

:W2kZ
if exist %mt%.* del %mt%.*
copy .\tool\WINDOWS\"%mt% Z XP.bat" %mt%.bat
echo DONE !
ping -n 6 localhost > nul
del .\MMC\MID.txt
goto exit

:VistaZ
if exist %mt%.* del %mt%.*
copy .\tool\WINDOWS\"%mt% Z.bat" %mt%.bat
echo DONE !
ping -n 6 localhost > nul
del .\MMC\MID.txt
goto exit

:exit

