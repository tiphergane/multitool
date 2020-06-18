#! /usr/bin/perl
#use File::Download;



# REM déchargement du runme1st
# set rn=.\runme1st
# if exist %rn%.bat ren %rn%.bak

start:
# REM init des variables
$nbimg='./Data/nbimg';
$fb='./Data/fastboot-linux';
$adb='./Data/adb-linux';
$pb='PC10IMG';
# $get='.\Data\wget.exe';
$ver="DESIRE Z";
$md5="2ff42897cd27e0db425a2cf36c8bd078";
# title "tiphergane multi tool for HTC $ver"
# REM Menu
system("clear");
print "*" x 80;
print "bienvenue dans le batch multiservice de tiphergane pour le HTC $ver\n";
print "*" x 80;
print "1: +Manipulation a faire permroot\n";
print "2: +Manipulation libre\n";
print "3: Quitter\n";
print "Faites Votre Choix: [1,2,3]?";
$reponse1 = <STDIN>;
if ($reponse1 == 1) {
	goto SOFF;
}
if ($reponse1 == 2) {
	goto FREE;
}
if ($reponse1 == 3) {
	goto end;
}


SOFF:
# REM Sub Menu
system("clear");
print "*" x 80;
print "bienvenue dans le batch multiservice de tiphergane pour le HTC $ver\n";
print "*" x 80;
print "1: -Manipulation a faire S-OFF\n";
print "	1: Splash Changer\n";
print "	2: Flash du Recovery\n";
print "	3: Couper le son au demarrage du GSM\n";
print "	4: +Desimlockage, SuperCID et S-OFF (Permroot OBLIGATOIRE)\n";
print "	5: Passage sur le ACE PVT ENG S-OFF (Permroot OBLIGATOIRE)\n";
print "	6: Retour au menu precedent\n";
print "2: +Manipulation libre\n";
print "3: Quitter\n";
print "Faites Votre Choix: [1,2,3,4,5,6]?";
$reponse = <STDIN>;
if ($reponse == 1) {
	goto splash;
}
if ($reponse == 2) {
	goto recovery;
}
if ($reponse == 3) {
	goto sound;
}
if ($reponse == 4) {
	goto CID;
}
if ($reponse == 5) {
	goto ACE;
}
if ($reponse == 6) {
	goto start;
}


CID:
# REM Sub Menu
system("clear");
print "*" x 80;
print "bienvenue dans le batch multiservice de tiphergane pour le HTC $ver\n";
print "*" x 80;
print "1: -Manipulation a faire S-OFF\n";
print "	1: Splash Changer\n";
print "	2: Flash du Recovery\n";
print "	3: Couper le son au demarrage du GSM\n";
print "	4: -Desimlockage, SuperCID et S-OFF (Permroot OBLIGATOIRE)\n";
print "		1: Desimlockage\n";
print "		2: SuperCID\n";
print "		3: S-OFF\n";
print "		4: S-ON\n";
print "		5: Tout d'un coup\n";
print "		6: retour au menu precedent\n";
print "	5: Retour au menu precedent\n";
print "2: +Manipulation libre\n";
print "3: Quitter\n";
print "Faites Votre Choix: [1,2,3,4,5,6]?";
$reponse = <STDIN>;
if ($reponse == 1) {
	goto simlock;
}
if ($reponse == 2) {
	goto super;
}
if ($reponse == 3) {
	goto off;
}
if ($reponse == 4) {
	goto on;
}
if ($reponse == 5) {
	goto all;
}
if ($reponse == 6) {
	goto SOFF;
}

FREE:
# REM Sub Menu
system("clear");
print "*" x 80;
print "bienvenue dans le batch multiservice de tiphergane pour le HTC $ver\n";
print "*" x 80;
print "1: +Manipulation a faire S-OFF\n";
print "2: -Manipulation libre\n";
print "	1: Flash de la ROM par $pb.ZIP\n";
print "	2: MMC/CID identification\n";
print "	3: Forcer l'installation sur la SDCARD ROM Froyo\n";
print "	4: Installer Visionary r14\n";
print "	5: Gerer la SD via Windows\n";
print "	6: Downgrade 1.7x vers 1.31.405.3\n";
print "	7: Verification des secu_flags\n";
print "	8: Retour au menu precedent\n";
print "3: Quitter\n";
print "Faites Votre Choix: [1,2,3,4,5,6,7,8]?";
$reponse = <STDIN>;
if ($reponse == 1) {
	goto PB99IMG;
}
if ($reponse == 2) {
	goto mmc;
}
if ($reponse == 3) {
	goto install;
}
if ($reponse == 4) {
	goto sd;
}
if ($reponse == 5) {
	goto apk;
}
if ($reponse == 6) {
	goto down;
}
if ($reponse == 7) {
	goto verify;
}
if ($reponse == 8) {
	goto start;
}

splash:
# REM remplacement du splash screen
system("clear");
print "*" x 80;
print " 				HTC splash flasher\n";
print "  				(c) tiphergane\n";
print "*" x 80;
# echo.
print "N'oubliez pas de mettre l'image au format 480*800 24Bits a la racine du repertoire\n";
# REM effacement des possibles reste d'image
print "comment s'appelle ton fichier splash (avec le .bmp a la fin merci) ?\n";
$img = <STDIN>;
unlink glob "*.bmp.nb";
unlink glob "*.img";
# resize de l'image au norme du HTC $ver
system("$nbimg -F $img -w 480 -h 800");
# REM renommage du fichier .bmp.nb en .img
rename ("*.bmp.nb","*.img");
# REM reboot du GSM en mode fastboot
system("adb reboot bootloader");
# REM flashage du Splashscreen par defaut
system("fastboot flash splash1 *.img");
# REM reboot du GSM
system("fastboot reboot");
goto greetz;

PB99IMG:
# REM maj de la ROM via un PB99IMG venant de chez HTC
system("clear");
print "*" x 80;
print "            				HTC PB99IMG Pusher\n";
print "            					(c) tiphergane\n";
print "*" x 80;
$loop=1;
if (-e "$pb.zip")
{
	print "test du fichier existant\n";
	goto md5;
}
else {
	print "pas de présence de ZIP, on passe au telechargement\n";
	goto dl;
}
md5:
system("md5sum $pb.zip | grep $md5");
if ($? == 0) {
	goto snd;
} else {
	unlink glob "$pb.zip";
	goto dl;
}

dl:
if ( $loop == 1)
{
	goto enautia;
}
if ( $loop == 2)
{
	goto dropbox;
}
if ( $loop == 3)
{
	goto free;
}
if ( $loop >> 3)
{
	print "plus de 3 essaies on ete realise, retour de la boucle a 0\n";
	print "il ce peut que le zip soient en cours de changement\n";
	goto PB99IMG;
}

enautia:
$url = "http://e-nautia.com/people/tiphergane/disk/HTC%20desire%20multi%20tool/DESIRE/$pb.zip";
goto lnk;

dropbox:
$url = "http://dl.dropbox.com/u/18631295/$pb.zip";
goto lnk;

free:
$url = "http://tiphergane.free.fr/DESIRE/$pb.zip";
goto lnk;

lnk:
$loop++;
unlink glob '$pb.zip';
system("wget $url");
goto md5;

snd:
print "Envoi du fichier a la racine de la SDCARD, ca peut etre TREEEEEEEEEES long (moy 100 sec, plus sur les DHD et DZ)\n";
# REM envoie du zip a la racine de la SDCARD
system("$adb kill-server");
system("$adb start-server > /dev/null");
system("$adb push $pb.zip /sdcard/$pb.zip");
print "redemarrage du GSM en cours sur le bootloader\n";
# REM Reboot le GSM en mode bootloader
system("$adb reboot bootloader");
goto greetz;

mmc:
# REM récupération de l'identifieur MMC/CID, récupération dans MMCx.txt
system("clear");
print "*" x 80;
print "            					HTC MMC/CID \n";
print "            					(c) tiphergane\n";
print "*" x 80;
print "quel est ton CID\n";
system("$adb shell getprop ro.cid");
print "Test sur MMC2\n";
system("$adb shell cat /sys/class/mmc_host/mmc2/mmc2:*/cid >> ./MMC/MMC.txt");
system("cat ./MMC/MMC.txt | grep --only-matching -E '^[0-9a-z]'");
sleep 5;
goto greetz;

recovery:
# REM Flashasge du recovery
system("clear");
print "*" x 80;
print "            					HTC recovery flasher\n";
print "            					(c) tiphergane\n";
print "*" x 80;
print "Quel recovery voulez vous utiliser ?\n";
print "1: Clockwork\n";
print "2: NE ME CHOISIS PAS\n";
print "Faites Votre Choix: [1,2]?";
$reponse = <STDIN>;
if ($reponse == 1) {
	goto clock;
}
if ($reponse == 2) {
	goto adb;
}

clock:
print "recuperation du recovery clockwork 2.5.0.7 pour le HTC ($ver)\n";
$url = "http://mirrorbrain.cyanogenmod.com/cm/recoveries/recovery-clockwork-3.0.0.5-vision.img";
system("wget $url");
print "passage en fastboot\n";
system("$adb reboot bootloader");
print "flash du recovery\n";
system("$fb flash recovery recovery-clock*.img");
print "reboot du GSM\n";
system("$fb reboot");
unlink glob "*.img";
goto greetz;

adb:
print "FATAL ERROR YOU'VE JUST BRICK YOUR $ver PRESS ANY KEY IF YOU ARE LUCKY\n";
sleep 5;
goto greetz;

sound:
system("clear");
print "*" x 80;
print "            					HTC boot silencer\n";
print "*" x 80;
print "HTC Really QUIETLY briliant ;)\n";
# REM on redemarre en recovery
print "redemarrage en recovery\n";
system("$adb reboot recovery");
# REM print "appuyez sur une touche des que le GSM est en recovery
# REM pause
# REM attente du GSM
print "attente de 60 sec le temps que le GSM reboot en recovery\n";
sleep 60;
# REM on monte le repertoire system
print "on monte le repertoire /system\n";
system("$adb shell mount /system");
# REM On renome le fichier MP3 en MP3.nothanks
print "renommage du fichier son\n";
system("$adb shell mv /system/customize/resource/android_audio.mp3 /system/customize/resource/android_audio.mp3.nothanks");
# REM reboot du GSM en fin de travail
print "reboot du GSM\n";
system("$adb reboot");
goto greetz;

apk:
# REM mise a jour du HBOOT modifié par Alpharev
system("clear");
print "*" x 80;
print "            					Visionary r14 install\n";
print "*" x 80;
$vi='./Data/com.*.apk';
print "envoi du Visionary dans la SDCARD\n";
system("$adb install -l $vi");
print "DONE !!!!\n";
sleep 5;
goto greetz;

install:
# REM forcer les installations d'apk sur la SD
system("clear");
print "*" x 80;
print "            					HTC APP on SD\n";
print "            					© tiphergane\n";
print "*" x 80;
# echo.
print "Quelle politique pour l'installation des APP\n";
print "1: Installation Automatique\n";
print "2: Installation sur GSM\n";
print "3: Installation sur SDCARD\n";
print "Faites Votre Choix: [1,2,3]?";
$reponse = <STDIN>;
if ($reponse == 1) {
	goto auto;
}
if ($reponse == 2) {
	goto gsm;
}
if ($reponse == 3) {
	goto SD;
}

auto:
print "mode Auto par le GSM\n";
system("$adb shell pm setInstallLocation 0");
goto greetz;
GSM:
print "mode sur le GSM\n";
system("$adb shell pm setInstallLocation 1");
goto greetz;
SD:
print "mode sur la SD\n";
system("$adb shell pm setInstallLocation 2");
goto greetz;

# :win
# REM lancer la MMC de gestion des disques
# &Clear;
# &Clear;
# echo.
# print "*" x 80;
# print "            					Gestion volumes SD
# print "            					© tiphergane
# print "*" x 80;
# echo.
# mmc diskmgmt.msc
# goto greetz

down:
# REM downgrade de la ROM de la version 1.7 a la version 1.31
# REM http://forum.xda-developers.com/showthread.php?t=905003
system("clear");
print "*" x 80;
print "            					HTD VISION ($ver) Downgrade\n";
print "http://forum.xda-developers.com/showpost.php?p=10122671\n";
print "*" x 80;
# echo.
$ps='./Data/psneuter';
$misc='.\Data\misc_version';
# REM envoie des fichier necéssaire au downgrade sur /data/local/tmp
system("$adb push $ps /data/local/tmp");
system("$adb push $misc /data/local/tmp");
system("$adb shell chmod 777 /data/local/tmp/psneuter");
system("$adb shell chmod 777 /data/local/tmp/misc_version");
system("$adb shell /data/local/tmp/psneuter");
system("$adb wait-for-device");
system("$adb shell /data/local/tmp/misc_version -s 1.31.405.6");
print "nice done\n";
sleep 5;
goto PB99IMG;

all:
# REM desimlockage et superCID du Mobile et S-OFF
system("clear");
print "*" x 80;
print "            		HTD ACE ($ver) All-in-one\n";
print "*" x 80;
# echo.
$gf='./Data/gfree';
$gfv='./Data/gfree_verify';
# REM envoie des fichier necéssaire au desimlock sur /data/local/
system("$adb push $gf /data/local/");
system("$adb push $gfv /data/local/");
system("$adb shell chmod 777 /data/local/gfree_verify");
system("$adb shell chmod 777 /data/local/gfree");
system("$adb shell su -c '/data/local/gfree -f'");
system("$adb sync");
system("$adb reboot");
goto greetz;

super:
# REM desimlockage et superCID du Mobile
system("clear");
print "*" x 80;
print "            		HTD ACE ($ver) SuperCID\n";
print "*" x 80;
$gf='./Data/gfree';
$gfv='./Data/gfree_verify';
# REM envoie des fichier necéssaire au desimlock sur /data/local/
system("$adb push $gf /data/local/");
system("$adb push $gfv /data/local/");
system("$adb shell chmod 777 /data/local/gfree_verify");
system("$adb shell chmod 777 /data/local/gfree");
system("$adb shell su -c '/data/local/gfree -c 11111111'");
system("$adb sync");
system("$adb reboot");
goto greetz;

simlock:
# REM desimlockage et superCID du Mobile
system("clear");
print "*" x 80;
print "            		HTD ACE ($ver) Desimlock\n";
print "*" x 80;
$gf='./Data/gfree';
$gfv='./Data/gfree_verify';
# REM envoie des fichier necéssaire au desimlock sur /data/local/
system("$adb push $gf /data/local/");
system("$adb push $gfv /data/local/");
system("$adb shell chmod 777 /data/local/gfree_verify");
system("$adb shell chmod 777 /data/local/gfree");
system("$adb shell su -c '/data/local/gfree -S'");
system("$adb sync");
system("$adb shell /data/local/gfree_verify");
system("$adb reboot");
goto greetz;

off:
# REM desimlockage et superCID du Mobile
system("clear");
print "*" x 80;
print "            		HTD ACE ($ver) S-OFF\n";
print "*" x 80;
$gf='./Data/gfree';
# REM envoie des fichier necéssaire au desimlock sur /data/local/
system("$adb push $gf /data/local/");
system("$adb push $gfv /data/local/");
system("$adb shell chmod 777 /data/local/gfree_verify");
system("$adb shell chmod 777 /data/local/gfree");
system("$adb shell su -c '/data/local/gfree -s off'");
system("$adb sync");
system("$adb reboot");
goto greetz;

on:
# REM desimlockage et superCID du Mobile
syte("clear");
print "*" x 80;
print "            		HTD ACE ($ver) S-ON\n";
print "*" x 80;
$gf='./Data/gfree';
# REM envoie des fichier necéssaire au desimlock sur /data/local/
system("$adb push %gf% /data/local/");
system("$adb push %gfv% /data/local/");
system("$adb shell chmod 777 /data/local/gfree_verify");
system("$adb shell chmod 777 /data/local/gfree");
system("$adb shell su -c '/data/local/gfree -s on'");
system("$adb sync");
system("$adb shell /data/local/gfree_verify");
system("$adb reboot");
goto greetz;

ACE:
# REM Verfication de l'archive
system("clear");
print "*" x 80;
print "            		HTD ACE ($ver) ACE PVT ENG S-OFF\n";
print "*" x 80;
# REM Flash du hboot en ACE PVT ENG S-OFF
system("$adb push .\Data\DHD /sdcard/DHD/");
system("$adb shell su -c 'sh /sdcard/DHD/check'");
print "avez vous eu les messages suivants\n";
print "insmod: init_module '/sdcard/DHD/wpx.ko' failed (Function not implemented)\n";
print "ou\n";
print "insmod: can't insert '/sdcard/DHD/wpx.ko': Function not implemented\n";
print "oui (1) non (2)\n";
$reponse = <STDIN>;
if ($reponse == 1) {
	goto ACE1;
}
if ($reponse == 2) {
	goto error;
}


ACE1:
# REM Backup du HBOOT
system("clear");
print "*" x 80;
print "            		HTD ACE ($ver) ACE PVT ENG S-OFF\n";
print "*" x 80;
# REM Flash du hboot en ACE PVT ENG S-OFF
print "Flash du hboot en ACE PVT ENG S-OFF, faites la manipulation avec attention\n";
system("$adb shell su -c 'sh /sdcard/DHD/backup'");
print "La somme des MD5 correspond elle bien ?\n";
print "oui (1) non (2)\n";
$reponse = <STDIN>;
if ($reponse == 1) {
	goto ACE2;
}
if ($reponse == 2) {
	goto error;
}

ACE2:
# REM Flash du HBOOT ENG
system("clear");
print "*" x 80;
print "            		HTD ACE ($ver) ACE PVT ENG S-OFF\n";
print "*" x 80;
# REM Flash du hboot en ACE PVT ENG S-OFF
print "Flash du hboot en ACE PVT ENG S-OFF, faites la manipulation avec attention\n";
system("$adb shell su -c 'sh /sdcard/DHD/hboot'");
print "Si la premiere somme MD5 = la Seconde alors YOU WIN\n";
print "Si la premiere somme MD5 = La Troisieme alors YOU FAILED BUT NOT LEATHAL\n";
print "Si la premiere somme MD5 est differente des autre MD5\n";
print "EPIC FAIL, DO NOT REBOOT THE PHONE OR HE WILL BE BRIKED\n";
print "Win (1) Failed (2) Leathal (3)\n";
$reponse = <STDIN>;
if ($reponse == 1) {
	goto recovery;
}
if ($reponse == 2) {
	goto error;
}
if ($reponse == 3) {
	goto oups;
}

error:
print "une erreur est survenue durant la procedure, elle n'est pas grave pour le GSM\n";
print "et vous pouvez le redemarrer\n";
sleep 5;
goto greetz;

oups:
print "la on peut pleurer, NE PAS REBOOTER LE GSM SOUS RISQUE DE LE BRIQUER\n";
print "Va chercher de l'aide sur XDA-dev\n";
sleep 15;
goto greetz;

verify:
# vérification des secu_flag et du CID
system("clear");
print "*" x 80;
print "            					HTC gfree_verify\n";
print "*" x 80;
$gfv="./Data/gfree_verify";
# envoie des fichier necéssaire au desimlock sur /data/local/
system("$adb push $gfv /data/local/");
system("adb% shell chmod 777 /data/local/gfree_verify");
print "verification des flags avec gfree_verify\n";
# on redemarre en recovery
print "redemarrage en recovery\n";
system("$adb reboot recovery");
print "pause de 60 sec le temps de passer en mode recovery\n";
sleep 60;
# REM on monte le repertoire system
system("$adb kill-server");
system("$adb start-server");
print "on monte le repertoire /system\n";
system("$adb shell mount /system");
print "on monte le repertoire /data\n";
system("$adb shell mount /data");
print "lancement de la verification\n";
system("$adb shell mv /data/local/gfree_verify");
sleep 60;
# REM reboot du GSM en fin de travail
print "reboot du GSM\n";
system("$adb reboot");
goto greetz;

greetz:
system("clear");
print "*" x 80;
print "               Greetz to XDA-Dev     ";
print "			  	Korben.info	";
print "				forum.htc-dev.fr	";
print "                   			(c) tiphergane  	";
print "*" x 80;
sleep 5;
# REM init des variable quit or menu
print "retour au menu (1) ou exit (2)\n";
$reponse = <STDIN>;
if ($reponse == 1) {
	goto start;
}
if ($reponse == 2) {
	goto end;
}


end:
# REM fin du batch
sleep 5;
