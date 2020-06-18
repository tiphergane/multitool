#!usr/bin/perl

# init des variables
$mt=update;
# REM Menu
system("uname -a | grep Linux > /dev/null");
if ($? == 0) {
	$wget="wget";
	$unrar="unrar";
	check:
	system("whereis unrar > unrar.txt");
	system('sed -n "/bin/p" ./unrar.txt > ./unrar.tmp');
	system("test -s unrar.tmp"); 
	if ( $? == 0 ) {
		print "unrar est présent sur la machine\n";
		goto debut;
	} else {
		print "\t \t \t installation d'unrar\n";
		system("sudo apt-get install -y unrar");
		goto check;
	}
} else {
	$wget="curl -O";
	$unrar="./Data/unrar";
	goto debut;
}

debut:
system("clear");
print "*" x 80;
print "\t \t \t \t bienvenue dans le batch d'update\n";
print "*" x 80;
print "1: update\n";
print "2: Quitter \n";
print "Faite Votre Choix: [1,2]?\n";
$reponse1 = <STDIN>;
if ($reponse1 == 1) {
	goto up;
}
if ($reponse1 == 2) {
	goto end;
}

up:
unlink glob "$mt.txt";
unlink glob "*.tmp";
unlink glob "*.rar";
system("$wget http://tiphergane.free.fr/DESIRE/$mt.txt 1>/dev/tty 2>test.tmp");
system('sed -n "/404 Not Found/p" ./test.tmp > ./sf_404.tmp');
system("test -s sf_404.tmp"); 
if ( $? == 0 ) {
	print "Oups: No update found on server\n";
	goto exit;
}

open VERSION, "<", "$mt.txt" or die $!;
open LOCAL, "<", "./Data/update/$mt.txt" or die $!;
$local=$mt.txt;
$cloud="./Data/update/$mt.txt";

while (<VERSION>) {
	$res=$_;
}
close VERSION;

while (<LOCAL>) {
	$rev=$_;
}
close LOCAL;

if ( $rev == $res ) {
	print "Il n'y a pas d'update a faire\n";
	foreach $fichier (<*.tmp>) {
		unlink ($fichier) or
		die "probleme pour detruire $fichier";
	}
	foreach $fichier (<*.txt>) {
		unlink ($fichier) or
		die "probleme pour detruire $fichier";
	}
	foreach $fichier (<*.rar>) {
		unlink ($fichier) or
		die "probleme pour detruire $fichier";
	}
	goto exit;
} else {
	print "Update FOUND! on lance le process\n";
	system("echo $res > ./Data/update/$mt.txt\n");
	print "telechargement de l'update $mt$res en cours:\n";
	$up="http://tiphergane.free.fr/DESIRE/update/$mt$res.rar";
	print "update en cours\n";
	system("$wget $up");
	system("$unrar x -y $mt$res.rar");
	foreach $fichier (<*.tmp>) {
		unlink ($fichier) or
		die "probleme pour detruire $fichier";
	}
	foreach $fichier (<*.txt>) {
		unlink ($fichier) or
		die "probleme pour detruire $fichier";
	}
	foreach $fichier (<*.rar>) {
		unlink ($fichier) or
		die "probleme pour detruire $fichier";
	}
}

exit:
sleep 5;



