

#!/data/data/com.termux/files/usr/bin/bash
#Galaxy boot logo changer
#@filipe13
#Special thanks to @josuedemuniz

verde='\e[32;1m'
export benv="/data/data/com.termux/files/usr/BootPatcher"

mkdir -p "$benv/backup"

if ! command -v termux-setup-storage >/dev/null; then
echo "This script isn't being executed on Termux, please download Termux on Play Store and try again." && exit 1
fi

if ! su -c "id" | grep -q uid=0; then
  echo "Root access required!" && exit 1
fi

clear
echo -en "\e[1;36m"
echo "     ____________________"
echo "     Galaxy Boot Logo Patcher"
echo "          ____________________"
echo -e "     By: Filipe Daniel and ${verde}Josué de Muniz"
echo -e "         @filipe13         ${verde}@josuedemuniz"
echo -en "\e[1;36m"
echo "     ----------"
echo -en "\e[0;37m"
echo ""
echo ""

	mkdir -p $benv/logs/
echo "#BootPatcher logs, do not edit!" > $benv/logs/log.txt

if [ -z "$1" ]; then
  echo "Usage: "
  echo "$0 {patch|restore|backup|clean}"
  exit 1

elif [ "$1" = "patch" ]; then

	if [ ! -f /sdcard/1st.jpg ] && [ ! -f /sdcard/2nd.jpg ]; then
  		echo "Image file(s) missing!"
  		exit 1
  	fi

	if [ -d $benv/logs ]; then
		: > $benv/logs/log.txt
	fi

	if [ -d $benv/scripts ]; then
		rm -rf "$benv/scripts"
	fi

	mkdir -p $benv/scripts
	if [ ! -f $benv/scripts/patch.sh ]; then
		cat > $benv/scripts/patch.sh <<'EOF'
			#!/system/bin/sh
		
			alias 7z="/data/data/com.termux/files/usr/bin/7z"
			benv="/data/data/com.termux/files/usr/BootPatcher"
			rm -rf "$benv/patch"
			mkdir -p "$benv/patch/decompress" "$benv/patch/out"
			busybox echo "Backuping..."
			dd if=/dev/block/by-name/up_param of=$benv/patch/patch.bin &>> $benv/logs/log.txt 2>&1 && dd if=/dev/block/by-name/up_param of=$benv/backup/up_param.bin &>> $benv/logs/log.txt 2>&1
			busybox echo "Backup completed."
			busybox echo "Patching logo..."
			cd "$benv/patch/decompress"
			7z e "$benv/patch/patch.bin" &>> $benv/logs/log.txt
			if [ -f /sdcard/1st.jpg ] && [ ! -f /sdcard/2nd.jpg ]; then
				rm ./letter.jpg
				dd if="/sdcard/1st.jpg" of="./letter.jpg" &>> $benv/logs/log.txt
				7z a -ttar "$benv/patch/out/img.tar" "$benv/patch/decompress/*" &>> $benv/logs/log.txt && // $benv/patch/out/* /sdcard &>> $benv/logs/log.txt
				dd if=$benv/patch/out/img.tar of=/dev/block/by-name/up_param &>> $benv/logs/log.txt 2>&1
				busybox echo "Done! Only 1st logo was flashed."
			elif [ ! -f /sdcard/1st.jpg ] && [ -f /sdcard/2nd.jpg ]; then
				rm ./logo.jpg
				dd if="/sdcard/2nd.jpg" of="./logo.jpg" &>> $benv/logs/log.txt
				7z a -ttar "$benv/patch/out/img.tar" "$benv/patch/decompress/*" &>> $benv/logs/log.txt && cp $benv/patch/out/* /sdcard &>> $benv/logs/log.txt
				dd if=$benv/patch/out/img.tar of=/dev/block/by-name/up_param &>> $benv/logs/log.txt 2>&1
				busybox echo "Done! Only the second logo was flashed."
			else 
				rm ./logo.jpg && rm ./letter.jpg
				dd if="/sdcard/2nd.jpg" of="$benv/patch/decompress/logo.jpg"
				dd if="/sdcard/1st.jpg" of="$benv/patch/decompress/letter.jpg"
				7z a -ttar "$benv/patch/out/img.tar" "$benv/patch/decompress/*" &>> $benv/logs/log.txt && cp $benv/patch/out/* /sdcard &>> $benv/logs/log.txt
				dd if=$benv/patch/out/img.tar of=/dev/block/by-name/up_param &>> $benv/logs/log.txt 2>&1
				busybox echo "Done! Both logos were flashed."
			fi
EOF
	fi
	
	chmod u+x $benv/scripts/patch.sh
	su -c '/data/data/com.termux/files/usr/BootPatcher/scripts/patch.sh'
	echo -e "\e[1;32mBoot logo patched successfully!\e[0m"
	exit 0
	
elif [ "$1" = "backup" ]; then
	echo "Backuping"
	if [ ! -f $benv/backup/up_param.bin ]; then
		su -c 'dd if=/dev/block/by-name/up_param of=/data/data/com.termux/files/usr/BootPatcher/backup/up_param.bin' &>> $benv/logs/log.txt 2>&1
		echo -e "\e[1;32mBackup completed!\e[0m"
	else 
		echo "Error!"
		echo -e "\e[1;31mBackup already exists!\e[0m"
		exit 0
	fi
elif [ "$1" = "restore" ]; then
	echo "Restoring original boot logo..."
	if [ -f $benv/backup/up_param.bin ]; then
		su -c "dd if=/data/data/com.termux/files/usr/BootPatcher/backup/up_param.bin of=/dev/block/by-name/up_param" &>> $benv/logs/log.txt 2>&1
	echo -e "\e[1;32mRestore completed!\e[0m"
	else
		echo "Error!"
		echo -e "\e[1;31mBackup does not exist!\e[0m"
	fi
elif [ "$1" = "clean" ]; then
	su -c 'rm -rf $benv'
elif [ "$1" = "rmwarnings" ]; then

	if [ -d $benv/logs ]; then
		: > $benv/logs/log.txt
	fi

	if [ -d $benv/scripts ]; then
		rm -rf "$benv/scripts"
	fi

	mkdir -p $benv/scripts
	if [ ! -f $benv/scripts/warns.sh ]; then
	cat > $benv/scripts/warns.sh <<'EOF'
		#!/system/bin/sh
	
		alias 7z="/data/data/com.termux/files/usr/bin/7z"
		benv="/data/data/com.termux/files/usr/BootPatcher"
		rm -rf "$benv/patch"
		mkdir -p "$benv/patch/decompress" "$benv/patch/out"			busybox echo "Backuping..."
		dd if=/dev/block/by-name/up_param of=$benv/patch/patch.bin &>> $benv/logs/log.txt 2>&1 && dd if=/dev/block/by-name/up_param of=$benv/backup/up_param.bin &>> $benv/logs/log.txt 2>&1
		busybox echo "Backup completed."
		busybox echo "Removing bootloader unlocking warnings..."
		cd "$benv/patch/decompress"
		7z e "$benv/patch/patch.bin" &>> $benv/logs/log.txt
		rm "./svb_orange.jpg" "./booting_warning.jpg"
		7z a -ttar "$benv/patch/out/img.tar" "$benv/patch/decompress/*" &>> $benv/logs/log.txt && // $benv/patch/out/* /sdcard &>> $benv/logs/log.txt
		dd if=$benv/patch/out/img.tar of=/dev/block/by-name/up_param &>> $benv/logs/log.txt 2>&1
		busybox echo "Done! Warnings removed with success."
EOF
	chmod u+x $benv/scripts/warns.sh
	su -c "/data/data/com.termux/files/usr/BootPatcher/scripts/warns.sh"
fi
