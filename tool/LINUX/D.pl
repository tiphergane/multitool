#!/usr/bin/perl

start:
# REM init des variables
$root='./Data/D/linux/reflash';
$nbimg='./Data/nbimg';
$fb='./Data/fastboot-linux';
$adb='./Data/adb-linux';
$pb="PB99IMG";
$ver="DESIRE";
$md5="f88f2a9841bfa9da6c818d2827212abe";

# REM Menu
system("clear");
print "*" x 80;
print "bienvenue dans le batch multiservice de tiphergane pour le HTC $ver\n";
print "*" x 80;
print "1: +Manipulation a faire S-OFF\n";
print "2: +Manipulation libre\n";
print "3: Quitter\n";
print "Faites Votre Choix: [1,2,3]?\n";
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
print "	3: Mise a jour du HBOOT d'alpharev\n";
print "	4: Couper le son au demarrage du GSM\n";
print "	5: Retour au menu precedent\n";
print "2: +Manipulation libre\n";
print "3: Quitter\n";
print "Faites Votre Choix: [1,2,3,4,5]?\n";
$reponse1 = <STDIN>;
if ($reponse1 == 1) {
	goto splash;
}
if ($reponse1 == 2) {
	goto recovery;
}
if ($reponse1 == 3) {
	goto soff;
}
if ($reponse1 == 4) {
	goto sound;
}
if ($reponse1 == 5) {
	goto start;
}


FREE:
# REM Sub Menu
system("clear");
print "*" x 80;
print "bienvenue dans le batch multiservice de tiphergane pour le HTC $ver\n";
print "*" x 80;
print "1: +Manipulation a faire S-OFF\n";
print "2: -Manipulation libre\n";
print "	1: root du $ver\n";
print "	2: Flash de la ROM par $pb.ZIP\n";
print "	3: MMC/CID identification\n";
print "	4: Forcer l'installation sur la SDCARD ROM Froyo\n";
print "	5: Verification des secu_flag\n";
print "	6: Retour au menu precedent\n";
print "3: Quitter\n";
print "Faites Votre Choix: [1,2,3,4,5,6]?\n";
$reponse1 = <STDIN>;
if ($reponse1 == 1) {
	goto root;
}
if ($reponse1 == 2) {
	goto PB99IMG;
}
if ($reponse1 == 3) {
	goto mmc;
}
if ($reponse1 == 4) {
	goto install;
}
if ($reponse1 == 5) {
	goto verify;
}
if ($reponse1 == 6) {
	goto start;
}

root:
# REM Rootage du GSM avec unrEVOked
system("clear");
print "*" x 80;
print "                       		HTC quietly rooted\n";
print "                      			(c) tiphergane\n";
print "*" x 80;
print "Quelle methode voulez vous choisir ?\n";
print " 1: Unrevoked (pour les GSM non S-OFF)\n";
print " 2: Methode maison (pour les GSM S-OFF)\n";
print "Faites Votre Choix: [1,2]?\n";
$reponse1 = <STDIN>;
if ($reponse1 == 1) {
	goto rootEVO;
}
if ($reponse1 == 2) {
	goto rootMAN;
}

rootEVO:
print "Rootage du GSM avec la methode unrEVOked\n";
system("$root");
goto greetz;

rootMAN:
$rage='./Data/rage/';
print "Rootage du GSM avec la methode Maison (rageagainstthecage)\n";
system("$adb push %rage% /data/local/");
system("$adb shell chmod 0755 /data/local/rageagainstthecage-arm5.bin");
system("$adb shell /data/local/rageagainstthecage-arm5.bin");
system("$adb kill-server");
system("$adb start-server");
# REM $adb shell 'cat /proc/mount'
# REM echo "merci de garder les information de la ligne /dev/block/ XXXXXXX /system YYY ro 0 0"
system("$adb shell 'mount -o rw,remount -t yaffs2 /dev/block/mtdblock3 /system'");
system("$adb shell cat /data/local/Superuser.apk > /system/app/Superuser.apk");
system("$adb cat /data/local/su > /system/bin/su");
system("$adb shell chmod 4755 /system/bin/su");
system("$adb shell 'mount -o ro,remount -t yaffs2 /dev/block/mtdblock3 /system'");
system("$adb shell exit");
system("$adb shell exit");
sleep 10;
goto greetz;

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
print "Test sur MMC1\n";
system("$adb shell cat /sys/class/mmc_host/mmc1/mmc1:*/cid >> ./MMC/MMC.txt");
print "test sur MMC0\n";
system("$adb shell cat /sys/class/mmc_host/mmc0/mmc0:*/cid >> ./MMC/MMC.txt");
system("cat ./MMC/MMC.txt | grep --only-matching -E '^[0-9a-z]'");
sleep 5;
goto greetz;

recovery:
# REM Flashasge du recovery
system("clear");
print "*" x 80;
print "      					HTC recovery flasher\n";
print "      					(c) tiphergane\n";
print "*" x 80;
print "Quel recovery voulez vous utiliser ?\n";
print "echo 1: Clockwork\n";
print "echo 2: AmonRA\n";
print "Faites Votre Choix: [1,2]?\n";
$reponse1 = <STDIN>;
if ($reponse1 == 1) {
	goto clock;
}
if ($reponse1 == 2) {
	goto ra;
}

clock:
print "recuperation du recovery clockwork 2.5.0.7 pour le HTC BRAVO ($ver)\n";
$url="http://e-nautia.com/people/tiphergane/disk/HTC desire multi tool/RECOVERY/clockwork/recovery-clockwork-2.5.0.7-bravo.img";
system("wget $url");
print "flash du recovery\n";
print "passage en fastboot\n";
system("$adb reboot bootloader");
print "flash du recovery\n";
system("$fb flash recovery recovery-clock*.img");
print "reboot du GSM\n";
system("$fb reboot");
unlink glob "*.img";
goto greetz;

ra:
print "recuperation du recovery AmonRA pour le HTC BRAVO ($ver)\n";
$url="http://e-nautia.com/people/tiphergane/disk/HTC desire multi tool/RECOVERY/AmonRA/recovery-RA-$ver-v2.0.0.img";
system("wget $url");
print "passage en fastboot\n";
system("$adb reboot bootloader");
print "flash du recovery\n";
system("$fb flash recovery recovery-RA-*.img");
print "reboot du GSM\n";
system("$fb reboot");
unlink glob "recovery*.img";
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

soff:
# REM mise a jour du HBOOT modifié par Alpharev
system("clear");
print "*" x 80;
print "      					Alpharev HBOOT update\n";
print "*" x 80;
print "recuperation de la mise a jour du HBOOT alpharev\n";
$url=" http://alpharev.nl/bravo_alphaspl.img";
system("wget $url");
print "passage en fastboot\n";
system("$adb reboot bootloader");
print "flash du HBOOT\n";
system("$fb flash hboot bravo_*.img");
print "reboot du GSM\n";
system("$fb reboot");
unlink glob "bravo*.img";
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
# cls
# echo.
# print "*" x 80;
# print "      					Gestion volumes SD
# print "      					© tiphergane
# print "*" x 80;
# echo.
# mmc diskmgmt.msc
# goto greetz

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
print "vérification des flags avec gfree_verify\n";
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
sleep 5;
