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
set adb=.\Data\adb.exe

REM Menu
cls
echo.
echo ********************************************************************************
echo       bienvenue dans le batch de creation tun.ko pour le HTC DESIRE
echo                           		 Windows Version
echo ********************************************************************************
echo.
echo 1: Creation du tun.ko
echo 2: Quitter 
echo Faite Votre Choix: [1,2]?
set /p choix=
if %choix%==1 goto tun
if %choix%==2 goto exit

:tun
cls
echo.
echo ********************************************************************************
echo       bienvenue dans le batch de creation tun.ko pour le HTC DESIRE
echo                           		 Windows Version
echo ********************************************************************************
echo.
REM Lancement du daemon adb
%adb% kill-server
%adb% start-server > nul
%adb% push .\Data\tun /sdcard/
%adb% shell su -c 'sh /sdcard/tun.sh'
goto exit

:exit
ping -n 10 localhost > nul

