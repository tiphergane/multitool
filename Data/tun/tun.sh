#!/system/bin/sh

echo ""
echo "tun.ko creator"
echo ""
if ! [ -f "/system/lib/modules/tun.ko" ];
then
   echo "File version:"
cat /system/lib/modules/tun.ko | grep "tiphergane" || echo "version originale" 
fi
	if ! [ $? == 0 ]
	then
   echo "File does not exists"
   echo "Creation du module pour votre version:"
cat /proc/version | grep "Linux version" | sed -n "s/[^-]*-//p" | sed -e "s/^\(.\{8\}\).*/\1/"

cat /sdcard/tunbase.ko | sed -e "s/12345678/`cat /proc/version | grep "Linux version" | sed -n "s/[^-]*-//p" | sed -e "s/^\(.\{8\}\).*/\1/"`/" > /sdcard/tun.ko
else
echo "file is present"
fi

echo "installation du module"
cp /sdcard/tun.ko /system/lib/modules/tun.ko
echo ""

echo "chargement du module"
su -c 'insmod /system/lib/modules/tun.ko'
