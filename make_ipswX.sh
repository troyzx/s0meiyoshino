#!/bin/bash

################################
### s0meiyoshino old         ###
################################

#### Restore & Jailbreak iOS: 10.3.3 ####
IOSVERSION="10.3.3"
IOSBUILD="14G60"

#### Base iOS: 7.0.4 ####
BASEFWVER="7.0.4"
BASEFWBUILD="11B554a"
expdisk=0  #7.0-7.0.6: 0

#### Base iOS: 7.1.2 ####
#BASEFWVER="7.1.2"
#BASEFWBUILD="11D257"
#expdisk=1 #7.1-7.1.2: 1

#### Restore_Base iOS: 9.0 ####
RBASE_IOSVER="9.0"
RBASE_IOSBUILD="13A344"
IBSS9_IV="f47771607eb9761ee4d62bfde4853afd"
IBSS9_Key="a28a482dedea0079f79b19c0b77b8eca2f64371fed61bdd726dc6c5af6560758"
IBEC9_IV="437404a5b4165e635187a4e4b73a148b"
IBEC9_Key="85cb205cd551442e629ffb267708c5eafe5642c845d46becf7dc5ef5f6244ca4"
DTRE9_IV="3a91de7e4628baaac64e3ece33d512b9"
DTRE9_Key="37647ad6288ebb750449954648acb3604f7c24be9d089f840aa59529c84019d1"
LOGO9_IV="ffa75ed41e594e84e75d02cc77236651"
LOGO9_Key="1c3c32275bf4232fa58a67f72606a627b4b48774e6a9f1efa7326e6bd5e2626b"
KRNL9_IV="51e771501d7f6fc95de3d789cf87bdf7"
KRNL9_Key="00271f76c9e0728ed7b3cdb13c4ad4b7889b8fc59b42486d4aa068a48429277a"
RDSK9_IV="2feeecb321c7ae10307e5c268e427d71"
RDSK9_Key="520af67fc9e11360df3af4cfca79a406fe8e0bd365898fda89ddece7b65b86dc"

if [ -e "iPhone_4.0_32bit_"$IOSVERSION"_"$IOSBUILD"_Restore.ipsw" ]; then
echo "iPhone_4.0_32bit_"$IOSVERSION"_"$IOSBUILD"_Restore.ipsw OK"
else
echo "iPhone_4.0_32bit_"$IOSVERSION"_"$IOSBUILD"_Restore.ipsw does not exist"
exit
fi

if [ -e "iPhone5,2_"$RBASE_IOSVER"_"$RBASE_IOSBUILD"_Restore.ipsw" ]; then
echo "iPhone5,2_"$RBASE_IOSVER"_"$RBASE_IOSBUILD"_Restore.ipsw OK"
else
echo "iPhone5,2_"$RBASE_IOSVER"_"$RBASE_IOSBUILD"_Restore.ipsw does not exist"
exit
fi

if [ -e "iPhone5,2_"$BASEFWVER"_"$BASEFWBUILD"_Restore.ipsw" ]; then
echo "iPhone5,2_"$BASEFWVER"_"$BASEFWBUILD"_Restore.ipsw OK"
else
echo "iPhone5,2_"$BASEFWVER"_"$BASEFWBUILD"_Restore.ipsw does not exist"
exit
fi

if [ -d "tmp_ipsw" ]; then
rm -r tmp_ipsw
fi

mkdir tmp_ipsw
cd tmp_ipsw

unzip ../iPhone_4.0_32bit_"$IOSVERSION"_"$IOSBUILD"_Restore.ipsw -d $IOSBUILD

mkdir orig
mkdir "$IOSBUILD"/Downgrade
mv -v "$IOSBUILD"/Firmware/all_flash/iBoot.iphone5.RELEASE.img3 orig/
mv -v "$IOSBUILD"/kernelcache.release.iphone5 orig/
rm "$IOSBUILD"/BuildManifest.plist
rm "$IOSBUILD"/Firmware/dfu/iBSS.iphone5.RELEASE.dfu
rm "$IOSBUILD"/Firmware/dfu/iBEC.iphone5.RELEASE.dfu
rm "$IOSBUILD"/058-75393-062.dmg #Update
rm "$IOSBUILD"/058-75249-062.dmg #Erase
rm "$IOSBUILD"/kernelcache.release.iphone5b
rm "$IOSBUILD"/Firmware/Mav7Mav8-7.60.00.Release.bbfw
rm "$IOSBUILD"/Firmware/Mav7Mav8-7.60.00.Release.plist
rm "$IOSBUILD"/Firmware/dfu/iBEC.iphone5b.RELEASE.dfu
rm "$IOSBUILD"/Firmware/dfu/iBSS.iphone5b.RELEASE.dfu
rm "$IOSBUILD"/Firmware/all_flash/DeviceTree.n41ap.img3
rm "$IOSBUILD"/Firmware/all_flash/DeviceTree.n49ap.img3
rm "$IOSBUILD"/Firmware/all_flash/DeviceTree.n48ap.img3
rm "$IOSBUILD"/Firmware/all_flash/LLB.iphone5b.RELEASE.img3
rm "$IOSBUILD"/Firmware/all_flash/iBoot.iphone5b.RELEASE.img3
rm "$IOSBUILD"/Firmware/all_flash/LLB.iphone5.RELEASE.img3
rm "$IOSBUILD"/Firmware/all_flash/applelogo@2x~iphone.s5l8950x.img3
rm "$IOSBUILD"/Firmware/all_flash/batterycharging0@2x~iphone.s5l8950x.img3
rm "$IOSBUILD"/Firmware/all_flash/batterycharging1@2x~iphone.s5l8950x.img3
rm "$IOSBUILD"/Firmware/all_flash/batteryfull@2x~iphone.s5l8950x.img3
rm "$IOSBUILD"/Firmware/all_flash/batterylow0@2x~iphone.s5l8950x.img3
rm "$IOSBUILD"/Firmware/all_flash/batterylow1@2x~iphone.s5l8950x.img3
rm "$IOSBUILD"/Firmware/all_flash/glyphplugin@1136~iphone-lightning.s5l8950x.img3
rm "$IOSBUILD"/Firmware/all_flash/recoverymode@1136~iphone-lightning.s5l8950x.img3

if [ ! -e "../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/xpcd_cache_armv7s.dylib" ]; then
hdiutil attach -mountpoint rootfs/ "$IOSBUILD"/058-74968-062.dmg
cp -a -v rootfs/System/Library/Caches/com.apple.xpcd/xpcd_cache.dylib ../src/xpcd_cache.dylib
hdiutil detach rootfs/
lipo -thin armv7s ../src/xpcd_cache.dylib -output ../src/xpcd_cache_armv7s.dylib
bspatch ../src/xpcd_cache_armv7s.dylib ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/xpcd_cache_armv7s.dylib ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/xpcd_cache_armv7s.patch
fi

unzip -j ../iPhone5,2_"$RBASE_IOSVER"_"$RBASE_IOSBUILD"_Restore.ipsw "058-03706-363.dmg" -d $RBASE_IOSBUILD
unzip -j ../iPhone5,2_"$RBASE_IOSVER"_"$RBASE_IOSBUILD"_Restore.ipsw "kernelcache.release.n42" -d $RBASE_IOSBUILD
unzip -j ../iPhone5,2_"$RBASE_IOSVER"_"$RBASE_IOSBUILD"_Restore.ipsw "Firmware/dfu/*" -d $RBASE_IOSBUILD
unzip -j ../iPhone5,2_"$RBASE_IOSVER"_"$RBASE_IOSBUILD"_Restore.ipsw "Firmware/all_flash/all_flash.n42ap.production/applelogo@2x~iphone.s5l8950x.img3" -d $RBASE_IOSBUILD
unzip -j ../iPhone5,2_"$RBASE_IOSVER"_"$RBASE_IOSBUILD"_Restore.ipsw "Firmware/all_flash/all_flash.n42ap.production/DeviceTree.n42ap.img3" -d $RBASE_IOSBUILD
unzip -j ../iPhone5,2_"$BASEFWVER"_"$BASEFWBUILD"_Restore.ipsw "Firmware/all_flash/all_flash.n42ap.production/*" -d BaseFWBuild

mkdir "$IOSBUILD"/Firmware/all_flash/all_flash.n42ap.production
mv -v "$IOSBUILD"/Firmware/all_flash/DeviceTree.n42ap.img3 "$IOSBUILD"/Firmware/all_flash/all_flash.n42ap.production/DeviceTree.n42ap.img3
mv -v BaseFWBuild/LLB.n42ap.RELEASE.img3 "$IOSBUILD"/Firmware/all_flash/all_flash.n42ap.production/LLB.iphone5.RELEASE.img3
mv -v BaseFWBuild/applelogo@2x~iphone.s5l8950x.img3 "$IOSBUILD"/Firmware/all_flash/all_flash.n42ap.production/applelogo@2x~iphone.s5l8950x.img3
mv -v BaseFWBuild/batterycharging0@2x~iphone.s5l8950x.img3 "$IOSBUILD"/Firmware/all_flash/all_flash.n42ap.production/batterycharging0@2x~iphone.s5l8950x.img3
mv -v BaseFWBuild/batterycharging1@2x~iphone.s5l8950x.img3 "$IOSBUILD"/Firmware/all_flash/all_flash.n42ap.production/batterycharging1@2x~iphone.s5l8950x.img3
mv -v BaseFWBuild/batteryfull@2x~iphone.s5l8950x.img3 "$IOSBUILD"/Firmware/all_flash/all_flash.n42ap.production/batteryfull@2x~iphone.s5l8950x.img3
mv -v BaseFWBuild/batterylow0@2x~iphone.s5l8950x.img3 "$IOSBUILD"/Firmware/all_flash/all_flash.n42ap.production/batterylow0@2x~iphone.s5l8950x.img3
mv -v BaseFWBuild/batterylow1@2x~iphone.s5l8950x.img3 "$IOSBUILD"/Firmware/all_flash/all_flash.n42ap.production/batterylow1@2x~iphone.s5l8950x.img3
mv -v BaseFWBuild/glyphplugin@1136~iphone-lightning.s5l8950x.img3 "$IOSBUILD"/Firmware/all_flash/all_flash.n42ap.production/glyphplugin@1136~iphone-lightning.s5l8950x.img3
mv -v BaseFWBuild/iBoot.n42ap.RELEASE.img3 "$IOSBUILD"/Firmware/all_flash/all_flash.n42ap.production/iBoot.iphone5.RELEASE.img3
mv -v BaseFWBuild/recoverymode@1136~iphone-lightning.s5l8950x.img3 "$IOSBUILD"/Firmware/all_flash/all_flash.n42ap.production/recoverymode@1136~iphone-lightning.s5l8950x.img3
cp -a -v ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/manifest "$IOSBUILD"/Firmware/all_flash/all_flash.n42ap.production/manifest

mkdir dec
mkdir patch

../bin/xpwntool orig/kernelcache.release.iphone5 dec/kernelcache.release.iphone5.dec
../bin/CBPatcher dec/kernelcache.release.iphone5.dec patch/kernelcache.release.iphone5.dec $IOSVERSION
# KASLR must be disabled. Because mac_policy_ops patch was applied.
../bin/xpwntool patch/kernelcache.release.iphone5.dec "$IOSBUILD"/kernelcache.release.iphone5 -t orig/kernelcache.release.iphone5
../bin/ibotpatch orig/iBoot.iphone5.RELEASE.img3 patch/iBoot.iphone5.RELEASE.img3
cp -a -v ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/BuildManifest.plist "$IOSBUILD"/BuildManifest.plist
../bin/xpwntool "$RBASE_IOSBUILD"/iBSS.n42.RELEASE.dfu orig/iBSS.n42.RELEASE.dfu -iv $IBSS9_IV -k $IBSS9_Key -decrypt
../bin/xpwntool orig/iBSS.n42.RELEASE.dfu dec/iBSS.n42.RELEASE.dec
bspatch dec/iBSS.n42.RELEASE.dec patch/iBSS.n42.PWNED.dec ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/iPhone5,2_"$RBASE_IOSVER"_"$RBASE_IOSBUILD".bundle/iBSS.n42ap.RELEASE.patch
../bin/xpwntool patch/iBSS.n42.PWNED.dec "$IOSBUILD"/Firmware/dfu/iBSS.n42.RELEASE.dfu -t orig/iBSS.n42.RELEASE.dfu
../bin/xpwntool "$RBASE_IOSBUILD"/iBEC.n42.RELEASE.dfu orig/iBEC.n42.RELEASE.dfu -iv $IBEC9_IV -k $IBEC9_Key -decrypt
../bin/xpwntool orig/iBEC.n42.RELEASE.dfu dec/iBEC.n42.RELEASE.dec
bspatch dec/iBEC.n42.RELEASE.dec patch/iBEC.n42.PWNED.dec ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/iPhone5,2_"$RBASE_IOSVER"_"$RBASE_IOSBUILD".bundle/iBEC.n42ap.RELEASE.patch
../bin/xpwntool patch/iBEC.n42.PWNED.dec "$IOSBUILD"/Firmware/dfu/iBEC.n42.RELEASE.dfu -t orig/iBEC.n42.RELEASE.dfu
../bin/xpwntool "$RBASE_IOSBUILD"/DeviceTree.n42ap.img3 "$IOSBUILD"/Downgrade/DeviceTree.n42ap.img3 -iv $DTRE9_IV -k $DTRE9_Key -decrypt
../bin/xpwntool "$RBASE_IOSBUILD"/applelogo@2x~iphone.s5l8950x.img3 "$IOSBUILD"/Downgrade/applelogo@2x~iphone.s5l8950x.img3 -iv $LOGO9_IV -k $LOGO9_Key -decrypt
../bin/xpwntool "$RBASE_IOSBUILD"/kernelcache.release.n42 orig/kernelcache9.img3  -iv $KRNL9_IV -k $KRNL9_Key -decrypt
../bin/xpwntool orig/kernelcache9.img3 dec/kernelcache9.dec
../bin/CBPatcher dec/kernelcache9.dec dec/pwnkc9.dec $RBASE_IOSVER
../bin/xpwntool dec/pwnkc9.dec "$IOSBUILD"/Downgrade/kernelcache.release.n42 -t orig/kernelcache9.img3
../bin/xpwntool "$RBASE_IOSBUILD"/058-03706-363.dmg orig/ramdisk.dmg -iv $RDSK9_IV -k $RDSK9_Key -decrypt
../bin/xpwntool orig/ramdisk.dmg dec/ramdisk.dmg

hdiutil resize dec/ramdisk.dmg -size 50m
if [ -e "dec/ramdisk.dmg" ]; then
echo "OK"
else
exit
fi
sudo hdiutil attach -mountpoint ramdisk/ dec/ramdisk.dmg
sleep 1s
sudo mkdir ramdisk/jb
sudo tar -xvf ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/binJX.tar -C ramdisk/ --preserve-permissions
sudo cp -a -v patch/iBoot.iphone5.RELEASE.img3 ramdisk/iBEC
sudo cp -a -v ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/Cydia-10.tar ramdisk/jb/Cydia.tar
sudo cp -a -v ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/dirhelper ramdisk/jb/dirhelper
sudo cp -a -v ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/launchctl ramdisk/jb/launchctl
sudo cp -a -v ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/Cydia_Installer ramdisk/jb/rtbuddyd
sudo cp -a -v ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/sakura ramdisk/jb/CrashHousekeeping
sudo cp -a -v ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/com.apple.springboard.plist ramdisk/jb/com.apple.springboard.plist
sudo cp -a -v ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/fstab ramdisk/jb/fstab
sudo cp -a -v ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/xpcd_cache_armv7s.dylib ramdisk/jb/xpcd_cache.dylib
sudo mv -v ramdisk/usr/sbin/asr ramdisk/usr/sbin/asr_orig
sudo bspatch ramdisk/usr/sbin/asr_orig ramdisk/usr/sbin/asr ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/iPhone5,2_"$RBASE_IOSVER"_"$RBASE_IOSBUILD".bundle/asr.patch
sudo chmod 755 ramdisk/usr/sbin/asr
sudo mv -v ramdisk/usr/share/progressui/applelogo@2x.tga ramdisk/usr/share/progressui/applelogo@2x.tga_orig
sudo cp -a ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/sakura@2x.tga ramdisk/usr/share/progressui/applelogo@2x.tga
sudo rm ramdisk/usr/local/share/restore/options.n42.plist
sudo cp -a -v ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/options.n42.plist ramdisk/usr/local/share/restore/options.n42.plist
sudo mv -v ramdisk/sbin/reboot ramdisk/sbin/reboot_
if [ $expdisk == 0 ]; then
sudo cp -a ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/partition0 ramdisk/sbin/reboot
sudo cp -a ../src/iPhone5,2/11B554a/ramdiskH.dmg ramdisk/ramdiskH.dmg
fi
if [ $expdisk == 1 ]; then
sudo cp -a ../FirmwareBundles/iPhone5,2_"$IOSVERSION"_"$IOSBUILD".bundle/partition1 ramdisk/sbin/reboot
sudo cp -a ../src/iPhone5,2/11D257/ramdiskH.dmg ramdisk/ramdiskH.dmg
fi
sudo chmod 755 ramdisk/sbin/reboot
sleep 1s
sudo hdiutil detach ramdisk/
sleep 1s

../bin/xpwntool dec/ramdisk.dmg "$IOSBUILD"/Downgrade/ramdisk.dmg -t orig/ramdisk.dmg

rm -r orig
rm -r patch

cd "$IOSBUILD"
zip ../../iPhone5,2_"$IOSVERSION"_"$IOSBUILD"_Custom.ipsw -r0 *
cd ../../
rm -r tmp_ipsw

