@echo off

REM déchargement du runme1st
set rn=.\runme1st
if exist %rn%.bat ren %rn%.bak

:start
REM init des variables
set nbimg=.\Data\nbimg.exe
set fb=.\Data\fastboot.exe
set adb=.\Data\adb.exe
set pb=PD98IMG
set get=.\Data\wget.exe
set md5=.\Data\md5sum.exe
set ver=DESIRE HD
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
echo 1: +Manipulation a faire permroot
echo 2: +Manipulation libre
echo 3: Update
echo 4: Quitter
choice /C:1234 /M "Faites votre choix:"
if errorlevel 4 goto exit
if errorlevel 3 call update
if errorlevel 2 goto FREE
if errorlevel 1 goto S-OFF

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
echo		3: Couper le son au demarrage du GSM
echo		4: +Desimlockage, SuperCID et S-OFF (Permroot OBLIGATOIRE)
echo		5: Passage sur le ACE PVT ENG S-OFF (Permroot OBLIGATOIRE)
echo		6: Retour au menu precedent
echo 2: +Manipulation libre
echo 3: Update
echo 4: Quitter
choice /C:123456 /M "Faites votre choix:"
if errorlevel 6 goto start
if errorlevel 5 goto ACE
if errorlevel 4 goto CID
if errorlevel 3 goto sound
if errorlevel 2 goto recovery
if errorlevel 1 goto splash

:CID
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
echo		3: Couper le son au demarrage du GSM
echo		4: -Desimlockage, SuperCID et S-OFF (Permroot OBLIGATOIRE)
echo			1: Desimlockage
echo			2: SuperCID
echo			3: S-OFF
echo			4: S-ON
echo			5: Tout d'un coup
echo			6: retour au menu precedent
echo		5: Retour au menu precedent
echo 2: +Manipulation libre
echo 3: Update
echo 4: Quitter
choice /C:123456 /M "Faites votre choix:"
if errorlevel 6 goto S-OFF
if errorlevel 5 goto all
if errorlevel 4 goto on
if errorlevel 3 goto off
if errorlevel 2 goto super
if errorlevel 1 goto lock

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
echo		1: Flash de la ROM par %pb%.ZIP
echo		2: MMC/CID identification
echo		3: Forcer l'installation sur la SDCARD ROM Froyo
echo		4: Installer Visionary/GingerBreak selon la config
echo		5: Gerer la SD via Windows
echo		6: Downgrade 1.7x vers 1.31.405.3
echo		7: Verification des flags avec gfree_verify
echo		8: Installation des drivers HBOOT
echo		9: Verification de la GOLDCARD
echo 3: Update
echo 4: Quitter
choice /C:123456789 /M "Faites votre choix:"

if errorlevel 9 goto goldcard
if errorlevel 8 goto drivers
if errorlevel 7 goto verify
if errorlevel 6 goto down
if errorlevel 5 goto win
if errorlevel 4 goto apk
if errorlevel 3 goto install
if errorlevel 2 goto mmc
if errorlevel 1 goto PB99IMG



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
REM effacement des possibles reste d'image
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
if not %gin%==1 goto greetz
goto 2.3.7.1

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
%adb% shell su -c 'dd if=/data/local/tmp/goldcard.img of=/dev/block/mmcblk1'
%adb% shell rm /data/local/tmp/goldcard.img
del .\MMC\MMC.txt
pause
goto greetz

:recovery
REM Flashage du recovery
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
choice /C:12 /M "Faites votre choix:"
if errorlevel 2 goto adb
if errorlevel 1 goto clock

:clock
echo recuperation du recovery clockwork 3.0.0.6 pour le HTC (%ver%)
%get% http://mirror.kanged.net/recoveries/recovery-clockwork-3.0.0.6-ace.img
echo passage en fastboot
%adb% reboot bootloader
echo flash du recovery
%fb% flash recovery recovery-clock*.img
echo reboot du GSM
%fb% reboot
if exist recovery*.img del recovery*.img
pause
goto greetz
:adb
echo recuperation du recovery AmonRA pour le HTC (%ver%)
%get% http://xdafil.es/DesireHD/Recovery%20Images/adb_recovery.img
echo passage en fastboot
%adb% reboot bootloader
echo flash du recovery
%fb% flash recovery adb_*.img
echo reboot du GSM
%fb% reboot
if exist adb_*.img del adb_*.img
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

:apk
REM mise a jour du HBOOT modifié par Alpharev
cls
echo.
echo ********************************************************************************
echo             					Visionary r14 install
echo ********************************************************************************
echo.
%adb% kill-server > nul
%adb% start-server > nul
echo verification de la version du build pour la methode de root
%adb% shell getprop ro.build.version.release > .\Data\build.txt
for /F %%a in (.\Data\build.txt) do echo Numero de build: %%a
for /F %%a in (.\Data\build.txt) do set build=%%a

if not %build%==2.2 goto Gingeroot
set vi=.\Data\com.*.apk
%adb% install -l %vi%
echo DONE !!!!
ping -n 6 localhost > nul
goto greetz

:Gingeroot
set vi=.\Data\GingerBreak*.apk
%adb% install -l %vi%
echo DONE !!!!
ping -n 6 localhost > nul
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
choice /C:123 /M "Faites votre choix:"
if errorlevel 3 goto SD
if errorlevel 2 goto GSM
if errorlevel 1 goto auto

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

:down
%adb% kill-server > nul
%adb% start-server > nul
echo verification de la version du build pour la methode de downgrade
%adb% shell getprop ro.build.version.release > .\Data\build.txt
for /F %%a in (.\Data\build.txt) do echo Numero de build: %%a
for /F %%a in (.\Data\build.txt) do set build=%%a
if %build%==2.3.7 goto 2.3.7.1
if not %build%==2.2 goto 2.2.1
echo le downgrade n'est pas obligatoire
ping -n 6 localhost > nul
goto greetz

:2.2.1

echo.
echo quel est la version de votre ROM
echo 1: froyo
echo 2: gingerbread
set /p OS=Faites Votre Choix: [1,2]
if %OS%==1 goto froyo
if %OS%==2 goto gingerbread
:froyo
REM downgrade de la ROM de la version 1.7 a la version 1.31
REM http://forum.xda-developers.com/showthread.php?t=905003
cls
echo.
echo ********************************************************************************
echo             					HTD ACE (%ver%) Downgrade
echo http://forum.xda-developers.com/showthread.php?t=905003
echo ********************************************************************************
echo.
del .\Data\build.txt
set ps=.\Data\psneuter
set misc=.\Data\misc_version
%adb% install -i ./Data/Superuser.apk
REM envoie des fichier necéssaire au downgrade sur /data/local/tmp
%adb% push %ps% /data/local/tmp
%adb% push %misc% /data/local/tmp
%adb% push %zerg% /data/local/tmp
%adb% shell chmod 777 /data/local/tmp/psneuter
%adb% shell chmod 777 /data/local/tmp/misc_version
%adb% shell /data/local/tmp/psneuter
%adb% wait-for-device
%adb% shell su -c '/data/local/tmp/misc_version -s 1.31.405.6'
echo nice done
pause
goto PB99IMG



:gingerbread
REM downgrade de la ROM de la version 2.3 a la version 1.31
REM http://forum.xda-developers.com/showthread.php?t=905003
cls
echo.
echo ********************************************************************************
echo             			HTD ACE (%ver%) Ginger Downgrade
echo http://forum.xda-developers.com/showthread.php?t=905003
echo ********************************************************************************
echo.
del .\Data\build.txt
set ps=.\Data\fre3vo
set misc=.\Data\misc_version
set zerg=.\Data\zergRush\zergRush
%adb% install -i ./Data/Superuser.apk
REM envoie des fichier necéssaire au downgrade sur /data/local/tmp
%adb% push %ps% /data/local/tmp
%adb% push %misc% /data/local/tmp
%adb% push %zerg% /data/local/tmp
%adb% shell chmod 777 /data/local/tmp/fre3vo
%adb% shell chmod 777 /data/local/tmp/misc_version
%adb% shell ./data/local/tmp/fre3vo -debug -start FAA90000 -end FFFFFFFF
%adb% wait-for-device
%adb% shell su -c '/data/local/tmp/misc_version -s 1.31.405.6'
echo nice done
pause
goto PB99IMG

:all
REM desimlockage et superCID du Mobile et S-OFF
cls
echo.
echo ********************************************************************************
echo             		HTD ACE (%ver%) All-in-one
echo ********************************************************************************
echo.
set gf=.\Data\gfree
set gfv=.\Data\gfree_verify
REM envoie des fichier necéssaire au desimlock sur /data/local/
%adb% push %gf% /data/local/
%adb% push %gfv% /data/local/
%adb% shell chmod 777 /data/local/gfree_verify
%adb% shell chmod 777 /data/local/gfree
%adb% shell su -c '/data/local/gfree -f'
%adb% sync
%adb% reboot
goto greetz

:super
REM desimlockage et superCID du Mobile
cls
echo.
echo ********************************************************************************
echo             		HTD ACE (%ver%) SuperCID
echo ********************************************************************************
echo.
set gf=.\Data\gfree
set gfv=.\Data\gfree_verify
REM envoie des fichier necéssaire au desimlock sur /data/local/
%adb% push %gf% /data/local/
%adb% push %gfv% /data/local/
%adb% shell chmod 777 /data/local/gfree_verify
%adb% shell chmod 777 /data/local/gfree
%adb% shell su -c '/data/local/gfree -c 11111111'
%adb% sync
%adb% reboot
goto greetz

:lock
REM desimlockage et superCID du Mobile
cls
echo.
echo ********************************************************************************
echo             		HTD ACE (%ver%) Desimlock
echo ********************************************************************************
echo.
set gf=.\Data\gfree
set gfv=.\Data\gfree_verify
REM envoie des fichier necéssaire au desimlock sur /data/local/
%adb% push %gf% /data/local/
%adb% push %gfv% /data/local/
%adb% shell chmod 777 /data/local/gfree_verify
%adb% shell chmod 777 /data/local/gfree
%adb% shell su -c '/data/local/gfree -S'
%adb% sync
%adb% shell /data/local/gfree_verify
%adb% reboot
goto greetz

:off
REM desimlockage et superCID du Mobile
cls
echo.
echo ********************************************************************************
echo             		HTD ACE (%ver%) S-OFF
echo ********************************************************************************
echo.
set gf=.\Data\gfree
REM envoie des fichier necéssaire au desimlock sur /data/local/
%adb% push %gf% /data/local/
%adb% push %gfv% /data/local/
%adb% shell chmod 777 /data/local/gfree_verify
%adb% shell chmod 777 /data/local/gfree
%adb% shell su -c '/data/local/gfree -s off'
%adb% sync
%adb% reboot
goto greetz

:on
REM desimlockage et superCID du Mobile
cls
echo.
echo ********************************************************************************
echo             		HTD ACE (%ver%) S-OFF
echo ********************************************************************************
echo.
set gf=.\Data\gfree
REM envoie des fichier necéssaire au desimlock sur /data/local/
%adb% push %gf% /data/local/
%adb% push %gfv% /data/local/
%adb% shell chmod 777 /data/local/gfree_verify
%adb% shell chmod 777 /data/local/gfree
%adb% shell su -c '/data/local/gfree -s on'
%adb% sync
%adb% shell /data/local/gfree_verify
%adb% reboot
goto greetz

:ACE
REM Verfication de l'archive
cls
echo.
echo ********************************************************************************
echo             		HTD ACE (%ver%) ACE PVT ENG S-OFF
echo ********************************************************************************
echo.
REM Flash du hboot en ACE PVT ENG S-OFF
%adb% push .\Data\DHD /sdcard/DHD/
%adb% shell su -c 'sh /sdcard/DHD/check'
echo avez vous eu les messages suivants
echo "insmod: init_module '/sdcard/DHD/wpx.ko' failed (Function not implemented)"
echo ou
echo "insmod: can't insert '/sdcard/DHD/wpx.ko': Function not implemented"
echo oui (1) non (2)
choice /C:12 /M "Faites votre choix:"
if errorlevel 2 goto error
if errorlevel 1 goto ACE1

:ACE1
REM Backup du HBOOT
cls
echo.
echo ********************************************************************************
echo             		HTD ACE (%ver%) ACE PVT ENG S-OFF
echo ********************************************************************************
echo.
REM Flash du hboot en ACE PVT ENG S-OFF
echo Flash du hboot en ACE PVT ENG S-OFF, faites la manipulation avec attention
%adb% shell su -c 'sh /sdcard/DHD/backup'
echo La somme des MD5 correspond elle bien ?
echo oui (1) non (2)
choice /C:12 /M "Faites votre choix:"
if errorlevel 2 goto error
if errorlevel 1 goto ACE2

:ACE2
REM Flash du HBOOT ENG
cls
echo.
echo ********************************************************************************
echo             		HTD ACE (%ver%) ACE PVT ENG S-OFF
echo ********************************************************************************
echo.
REM Flash du hboot en ACE PVT ENG S-OFF
echo Flash du hboot en ACE PVT ENG S-OFF, faites la manipulation avec attention
%adb% shell su -c 'sh /sdcard/DHD/hboot'
echo Si la premiere somme MD5 = la Seconde alors YOU WIN
echo Si la premiere somme MD5 = La Troisieme alors YOU FAILED BUT NOT LEATHAL
echo Si la premiere somme MD5 est differente des autres MD5
echo EPIC FAIL, DO NOT REBOOT THE PHONE OR HE WILL BE BRIKED
echo Win (1) Failed (2) Leathal (3)
choice /C:123 /M "Faites votre choix:"
if errorlevel 3 goto oups
if errorlevel 2 goto error
if errorlevel 1 goto recovery

:error
echo une erreur est survenue durant la procedure, elle n'est pas grave pour le GSM
echo et vous pouvez le redemarrer
pause
goto greetz

:oups
echo la on peut pleurer, NE PAS REBOOTER LE GSM SOUS RISQUE DE LE BRIQUER
echo Va chercher de l'aide sur XDA-dev
pause
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
echo appuyez sur une touche des que le GSM est en recovery
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
choice /C:12 /M "Faites votre choix:"
if errorlevel 2 goto exit
if errorlevel 1 goto start


:exit
REM fin du batch
