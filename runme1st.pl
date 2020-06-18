#!usr/bin/perl
use File::Copy;

start:
# REM init des variables
$mt="multitool";


# REM Menu
system("clear");
print "*" x 80;
print "\n";
print "\t \t \t bienvenue dans le batch multiservice de tiphergane pour le HTC DESIRE\n";
print "                            UNIX Version checker\n";
print "*" x 80;
print "\n";
print "1: Vérification de la version d'UNIX\n";
print "2: Quitter \n";
print "Faite Votre Choix: [1,2]?";
$reponse1 = <STDIN>;
if ($reponse1 == 1) {
	system("uname -a | grep Linux > /dev/null");
	if ($? == 0) {
		$adb="./Data/adb-linux";
		goto linux;
	} else {
		$adb="./Data/adb-mac";
		goto mac;
	}
}
if ($reponse1 == 2) {
	goto end;
}



mac:
system("$adb shell getprop ro.product.device > ./MMC/MID.txt");
open MID, "<", "./MMC/MID.txt" or die $!;
while (<MID>) {
	$MID=$_;
}
if ($MID==bravo) {
	unlink glob "$mt.pl";
	copy("./tool/MAC/D.pl","./$mt.pl") or die "Copy failed: $!";
	system("sh ./scripts/activate_mac");
	system("perl ./$mt.pl");
	goto end;
}
elsif ($MID==ace) {
	unlink glob "$mt.pl";
	copy("./tool/MAC/DHD.pl","./$mt.pl") or die "Copy failed: $!";
	system("sh ./scripts/activate_mac");
	system("perl ./$mt.pl");
	goto end;
}
elsif ($MID==vision) {
	unlink glob "$mt.pl";
	copy("./tool/MAC/Z.pl","./$mt.pl") or die "Copy failed: $!";
	system("sh ./scripts/activate_mac");
	system("perl ./$mt.pl");
	goto end;
}
else {
	print "Ton GSM $MID n'est pas supporte";
	goto end;
}





linux:
system("$adb shell getprop ro.product.device > ./MMC/MID.txt");
open MID, "<", "./MMC/MID.txt" or die $!;
while (<MID>) {
	$MID=$_;
}
if ($MID==bravo) {
	unlink glob "$mt.pl";
	copy("./tool/LINUX/D.pl","./$mt.pl") or die "Copy failed: $!";
	system("sh ./scripts/activate_linux");
	system("perl ./$mt.pl");
	goto end;
}
elsif ($MID==ace) {
	unlink glob "$mt.pl";
	copy("./tool/LINUX/DHD.pl","./$mt.pl") or die "Copy failed: $!";
	system("sh ./scripts/activate_linux");
	system("perl ./$mt.pl");
	goto end;
}
elsif ($MID==vision) {
	unlink glob "$mt.pl";
	copy("./tool/LINUX/Z.pl","./$mt.pl") or die "Copy failed: $!";
	system("sh ./scripts/activate_linux");
	system("perl ./$mt.pl");
	goto end;
}
else {
	print "Ton GSM $MID n'est pas supporte";
}



end:
close MID;
foreach $fichier (<./MMC/MID.txt>) {
	unlink glob ($fichier) or die "impossible de detruire $fichier";
}
sleep 2;

