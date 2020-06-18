@echo off

REM déchargement du runme1st
set rn=.\runme1st
if exist %rn%.bat ren %rn%.bak

:start
REM init des variables
set root=.\Data\D\reflash.exe
set nbimg=.\Data\nbimg.exe
set fb=.\Data\fastboot.exe
set adb=.\Data\adb.exe
set pb=PB99IMG
set get=.\Data\wget.exe
set ver=DESIRE
set cat=.\Data\cat.exe
set grep=.\Data\grep.exe
title "tiphergane multi tool for HTC %ver%"

REM Menu
cls
echo.
echo ********************************************************************************
echo       bienvenue dans le batch multiservice de tiphergane pour le HTC %ver%
echo ********************************************************************************
echo.
echo 1: +Manipulation a faire S-OFF
echo 2: +Manipulation libre
echo 3: Update
echo 4: Quitter
echo Faites Votre Choix: [1,2,3,4]?
set /p choix=
if %choix%==1 goto S-OFF
if %choix%==2 goto FREE
if %choix%==3 call update
if %choix%==4 goto EXIT

:S-OFF
REM Sub Menu
cls
echo.
echo ********************************************************************************
echo       bienvenue dans le batch multiservice de tiphergane pour le HTC %ver%
echo ********************************************************************************
echo.
echo 1: -Manipulation a faire S-OFF
echo		1: Splash Changer
echo		2: Flash du Recovery
echo		3: Mise a jour du HBOOT d'alpharev
echo		4: Couper le son au demarrage du GSM
echo		5: Retour au menu precedent
echo 2: +Manipulation libre
echo 3: Update
echo 4: Quitter
echo Faites Votre Choix: [1,2,3,4]?
set /p choix=
if %choix%==1 goto splash
if %choix%==2 goto recovery
if %choix%==3 goto soff
if %choix%==4 goto sound
if %choix%==5 goto start

:FREE
REM Sub Menu
cls
echo.
echo ********************************************************************************
echo       bienvenue dans le batch multiservice de tiphergane pour le HTC %ver%
echo ********************************************************************************
echo.
echo 1: +Manipulation a faire S-OFF
echo 2: -Manipulation libre
echo		1: Root
echo		2: Flash de la ROM par %pb%.ZIP
echo		3: MMC/CID identification
echo		4: Forcer l'installation sur la SDCARD ROM Froyo
echo		5: Gerer la SD via Windows
echo		6: Verification des Flags avec gfree_verify
echo		7: Installation des drivers HBOOT
echo		8: Verification de la GOLDCARD
echo		9: Retour au menu precedent
echo 3: Update
echo 4: Quitter
echo Faites Votre Choix: [1,2,3,4,5,6,7,8,9]?
set /p choix=
if %choix%==1 goto root
if %choix%==2 goto PB99IMG
if %choix%==3 goto mmc
if %choix%==4 goto install
if %choix%==5 goto win
if %choix%==6 goto verify
if %choix%==7 goto drivers
if %choix%==8 goto goldcard
if %choix%==9 goto start

:root
REM Rootage du GSM avec unrEVOked
cls
echo.
echo ********************************************************************************
echo                       		HTC quietly rooted
echo                      			(c) tiphergane
echo ********************************************************************************
echo.
echo Quelle methode voulez vous choisir ?
echo 1: Unrevoked (pour les GSM non S-OFF)
echo 2: Methode maison (pour les GSM S-OFF)
echo Faites Votre Choix: [1,2]?
set /p choix=
if %choix%==1 goto rootEVO
if %choix%==2 goto rootMAN

:rootEVO
echo Rootage du GSM avec la methode unrEVOked
set root=.\Data\D\reflash.exe
start /wait %root%
goto greetz

:rootMAN
if exist .\Data\done.txt goto done
set rage=.\Data\rage\su
set zerg=.\Data\zergRush\zergRush
echo Rootage du GSM avec la methode Maison (zergRush)
echo Ce fait en 2 fois, la premiere pour le zergRush, la seconde pour le rootage
ping -n 10 localhost > nul
%adb% push %rage% /data/local/
%adb% push %zerg% /data/local/tmp/
%adb% shell chmod 0755 /data/local/tmp/zergRush
%adb% shell /data/local/tmp/zergRush
echo done > .\Data\zerg.txt
:done
%adb% kill-server
%adb% start-server
REM %adb% shell 'cat /proc/mount'
REM echo "merci de garder les informations de la ligne /dev/block/ XXXXXXX /system YYY ro 0 0"
%adb% shell 'mount -o rw,remount -t yaffs2 /dev/block/mtdblock3 /system'
%adb% install -l .\Data\rage\Superuser.apk
%adb% cat /data/local/su > /system/bin/su
%adb% shell chmod 4755 /system/bin/su
%adb% shell 'mount -o ro,remount -t yaffs2 /dev/block/mtdblock3 /system'
%adb% shell rm -rf /data/local/su
%adb% shell rm -rf /data/local/tmp/zergRush
del .\Data\done.txt
%adb% shell exit
pause
goto greetz

:splash
REM remplacement du splash screen
cls
echo.
echo ********************************************************************************
echo                       		HTC splash flasher
echo                      			(c) tiphergane
echo ********************************************************************************
echo.
Echo N'oubliez pas de mettre l'image au format 480*800 24Bits a la racine du repertoire
REM effacement des possibles restes d'images
echo comment s'appelle le splash ?
set /p img=
if exist %img%.bmp.nb del %img%.bmp.nb
if exist %img%.img del %img%.img
REM resize de l'image au norme du HTC %ver%
%nbimg% -F %img%.bmp -w 480 -h 800
REM renommage du fichier .bmp.nb en .img
ren %img%.bmp.nb %img%.img
REM reboot du GSM en mode fastboot
%adb% reboot bootloader
REM flashage du Splashscreen par defaut
%fb% flash splash1 %img%.img
REM reboot du GSM
%fb% reboot
goto greetz

:PB99IMG
REM maj de la ROM via un PB99IMG venant de chez HTC
cls
echo.
echo ********************************************************************************
echo             				HTC %pb% Pusher
echo             					(c) tiphergane
echo ********************************************************************************
echo.
set md5=.\Data\md5sum.exe
set bcl=1
if exist %pb%.zip goto md5

:link
set /a ligne=%bcl%
REM récupération du fichier "in da cloud"
if %ligne%==1 goto e-nautia
if %ligne%==2 goto dropbox
if %ligne%==3 goto free
if %ligne% gtr 3 goto PB99IMG

:e-nautia
set link="http://e-nautia.com/people/tiphergane/disk/HTC desire multi tool/DESIRE/%pb%.zip"
goto lnk

:dropbox
set link=http://dl.dropbox.com/u/18631295/%pb%.zip
goto lnk

:free
set link=http://tiphergane.free.fr/DESIRE/%pb%.zip
goto lnk

:lnk
set /a bcl+=1
if exist %pb%.zip del %pb%.zip
%get% %link%
goto md5

:md5
if exist %pb%.md5 del %pb%.md5
%get% http://tiphergane.free.fr/DESIRE/%pb%.md5
%md5% -c %pb%.md5 > check.txt 
for /F "tokens=2" %%i in (check.txt) do set res=%%i
echo le MD5 est %res%


if %res%=="OK" (
echo le md5 correspond
ping -n 6 localhost > nul
goto send
)


if not "%res%"=="OK" (
echo le md5 ne correspond pas
ping -n 6 localhost > nul
goto link
)


:send
echo Envoi du fichier a la racine de la SDCARD, ca peut etre TREEEEEEEEEES long (moy 100 sec)
%adb% kill-server
%adb% start-server
REM envoi du zip a la racine de la SDCARD
%adb% push %pb%.zip /sdcard/%pb%.zip
echo redemarrage du GSM en cours sur le bootloader
REM Reboot le GSM en mode bootloader
%adb% reboot bootloader
goto greetz

:mmc
REM récupération de l'identifieur MMC/CID, récupération dans MMCx.txt
cls
echo.
echo ********************************************************************************
echo             					HTC MMC/CID
echo             					(c) tiphergane
echo ********************************************************************************
echo.
%adb% push .\Data\goldcard /data/local/tmp
%adb% shell chmod 777 /data/local/tmp/goldcard
if exist .\MMC\MMC.txt del .\MMC\MMC.txt
echo quel est ton CID
%adb% shell getprop ro.cid
echo Test sur MMC1
%adb% shell cat /sys/class/mmc_host/mmc1/mmc1:*/cid > .\MMC\MMC.txt
for /F %%a in (.\MMC\MMC.txt) do set lulu=%%a
echo Ton MMC est le:
%cat% .\MMC\MMC.txt | %grep% --only-matching -E "^[0-9a-z]*"
echo creation de la glodcard
%adb% shell /data/local/tmp/goldcard -c %lulu% -o /data/local/tmp/goldcard.img
%adb% shell su -c 'dd if=/data/local/tmp/goldcard.img of=/dev/block/mmcblk0'
%adb% shell rm /data/local/tmp/goldcard.img
del .\MMC\MMC.txt
pause
goto greetz

:recovery
REM Flashasge du recovery
cls
echo.
echo ********************************************************************************
echo             					HTC recovery flasher
echo             					(c) tiphergane
echo ********************************************************************************
echo.
echo Quel recovery voulez vous utiliser ?
echo 1: Clockwork
echo 2: AmonRA
echo "Faites Votre Choix: [1,2]?
set /p choix=
if %choix%==1 goto clock
if %choix%==2 goto Ra
:clock
echo recuperation du recovery clockwork 2.5.0.7 pour le HTC BRAVO (%ver%)
%get% "http://e-nautia.com/people/tiphergane/disk/HTC desire multi tool/DESIRE/RECOVERY/clockwork/recovery-clockwork-2.5.0.7-bravo.img"
echo passage en fastboot
%adb% reboot bootloader
echo flash du recovery
%fb% flash recovery recovery-clock*.img
echo reboot du GSM
%fb% reboot
if exist recovery*.img del recovery*.img
pause
goto greetz
:ra
echo recuperation du recovery AmonRA pour le HTC BRAVO (%ver%)
%get% "http://e-nautia.com/people/tiphergane/disk/HTC desire multi tool/DESIRE/RECOVERY/AmonRA/recovery-RA-%ver%-v2.0.0.img"
echo passage en fastboot
%adb% reboot bootloader
echo flash du recovery
%fb% flash recovery recovery-RA-*.img
echo reboot du GSM
%fb% reboot
if exist recovery*.img del recovery*.img
pause
goto greetz

:sound
REM récupération de l'identifieur MMC/CID, récupération dans MMCx.txt
cls
echo.
echo ********************************************************************************
echo             					HTC boot silencer
echo ********************************************************************************
echo.
echo HTC Really QUIETLY briliant ;)
REM on redemarre en recovery
echo redemarrage en recovery
%adb% reboot recovery
REM echo appuyez sur une touche des que le GSM est en recovery
REM pause
REM attente du GSM
pause
REM on monte le repertoire system
echo on monte le repertoire /system
%adb% shell mount /system
REM On renome le fichier MP3 en MP3.nothanks
echo renommage du fichier son
%adb% shell mv /system/customize/resource/android_audio.mp3 /system/customize/resource/android_audio.mp3.nothanks
REM reboot du GSM en fin de travail
echo reboot du GSM
%adb% reboot
pause
goto greetz

:soff
REM mise a jour du HBOOT modifié par Alpharev
cls
echo.
echo ********************************************************************************
echo             					Alpharev HBOOT update
echo ********************************************************************************
echo.
echo recuperation de la mise a jour du HBOOT alpharev
%get% http://alpharev.nl/bravo_alphaspl.img
echo passage en fastboot
%adb% reboot bootloader
echo flash du HBOOT
%fb% flash hboot bravo_*.img
echo reboot du GSM
%fb% reboot
if exist bravo*.img del bravo*.img
pause
goto greetz

:install
REM forcer les installations d'apk sur la SD
cls
echo.
echo ********************************************************************************
echo             					HTC APP on SD
echo             					© tiphergane
echo ********************************************************************************
echo.
echo Quelle politique pour l'installation des APP
echo 1: Installation Automatique
echo 2: Installation sur GSM
echo 3: Installation sur SDCARD
echo "Faites Votre Choix: [1,2,3]?
set /p choix=
if %choix%==1 goto auto
if %choix%==2 goto GSM
if %choix%==3 goto SD


:auto
echo mode Auto par le GSM
%adb% shell pm setInstallLocation 0
goto greetz
:GSM
echo mode sur le GSM
%asb% shell pm setInstallLocation 1
goto greetz
:SD
echo mode sur la SD
%adb% shell pm setInstallLocation 2
goto greetz

:win
REM lancer la MMC de gestion des disques
cls
echo.
echo ********************************************************************************
echo             					Gestion volumes SD
echo             					© tiphergane
echo ********************************************************************************
echo.
mmc diskmgmt.msc
goto greetz

:verify
cls
echo.
echo ********************************************************************************
echo             					HTC gfree_verify
echo ********************************************************************************
echo.
set gfv=.\Data\gfree_verify
REM envoie des fichier necéssaire au desimlock sur /data/local/
%adb% push %gfv% /data/local/
%adb% shell chmod 777 /data/local/gfree_verify
echo verification des flags avec gfree_verify
REM on redemarre en recovery
echo redemarrage en recovery
%adb% reboot recovery
REM echo appuyez sur une touche des que le GSM est en recovery
REM pause
REM attente du GSM
pause
REM on monte le repertoire system
%adb% kill-server
%adb% start-server
echo on monte le repertoire /system
%adb% shell mount /system
echo on monte le repertoire /data
%adb% shell mount /data
REM On renome le fichier MP3 en MP3.nothanks
echo lancement de la verification
%adb% shell /data/local/gfree_verify
pause
REM reboot du GSM en fin de travail
echo reboot du GSM
%adb% reboot
goto greetz

:drivers
cls
echo ********************************************************************************
echo             				HTC %ver% HBOOT drivers
echo             					(c) tiphergane
echo ********************************************************************************
set driver=".\Data\D\Android USB drivers\*.inf"
rundll32 SETUPAPI.DLL,InstallHinfSection DefaultInstall 132 %driver%
goto greetz

:goldcard
cls
echo ********************************************************************************
echo             				HTC %ver% goldcard checker
echo             					(c) tiphergane
echo ********************************************************************************
%adb% kill-server
%adb% start-server > nul
REM echo recuperation du CID
%adb% shell getprop ro.cid > .\MMC\CID.txt
for /F %%a in (.\MMC\CID.txt) do set cid=%%a
findstr %cid% .\Data\check.txt
if %errorlevel%==0 goto GC
del .\MMC\CID.txt
echo ton CID necessite une GOLDCARD
pause
goto greetz

:GC
del .\MMC\CID.txt
echo ton CID ne necessite pas de goldcard
pause
goto greetz


:greetz
REM Greetz
cls
echo.
echo ********************************************************************************
echo                Greetz to XDA-Dev     
echo			  	Korben.info	
echo 				forum.htc-dev.fr	
echo                    			(c) tiphergane  	
echo ********************************************************************************
echo.
pause
REM init des variable quit or menu
echo retour au menu (1) ou exit (2)
echo "Faites Votre Choix: [1,2]?
set /p choix=
if %choix%==1 goto start
if %choix%==2 goto exit

:exit
REM fin du batch

