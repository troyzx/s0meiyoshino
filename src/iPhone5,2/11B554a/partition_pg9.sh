#!/bin/bash

kpatch=0 #iOS7_remount_rootfs

### Mount Root/Data-FS
mount_hfs /dev/disk0s1s1 /mnt1
mount_hfs /dev/disk0s1s2 /mnt1/private/var
sleep 1s

### Disable OTA Update
rm -rf /mnt1/System/Library/LaunchDaemons/com.apple.softwareupdateservicesd.plist

#####################################################################
########################## Install Exploit ##########################
#####################################################################
Data_GUID="$((echo -e "i\n2\nq") | gptfdisk /dev/rdisk0s1 2>/dev/null | sed -n -e 's/^.*Partition unique GUID: //p')"
LogicalSector="$((echo -e "p\nq") | gptfdisk /dev/rdisk0s1 2>/dev/null | sed -n -e 's/^.*Logical sector size: //p' | sed 's/ .*//')"
System_LastSector="$((echo -e "i\n1\nq") | gptfdisk /dev/rdisk0s1 2>/dev/null | sed -n -e 's/^.*Last sector: //p' | sed 's/ .*//')"
Data_LastSector="$((echo -e "i\n2\nq") | gptfdisk /dev/rdisk0s1 2>/dev/null | sed -n -e 's/^.*Last sector: //p' | sed 's/ .*//')"
Data_Attributeflags="$((echo -e "i\n2\nq") | gptfdisk /dev/rdisk0s1 2>/dev/null | sed -n -e 's/^.*flags: //p')"
Exploit_LastSector="$((524288/$LogicalSector))"
BOOTLOADER="$((8388608/$LogicalSector))"
NOTSD="$(($Exploit_LastSector+$BOOTLOADER))"
Data_LastSectorSD="$(($Data_LastSector-$BOOTLOADER))"
New_Data_LastSector="$(($Data_LastSector-$NOTSD))"
New_Data_SectorSize="$(($New_Data_LastSector-$System_LastSector))"
New_Data_Size="$(($New_Data_SectorSize*$LogicalSector))"


### Resize Data-FS
hfs_resize /mnt1/private/var $New_Data_Size
sleep 1s

### Install exploit_1st
if [ "$Data_Attributeflags" = "0001000000000000" ]; then
echo -e "d\n2\nn\n\n$New_Data_LastSector\n\nc\n2\nData\nx\na\n2\n48\n\nc\n2\n$Data_GUID\ns\n4\nm\nn\n3\n\n$Data_LastSectorSD\n\nn\n4\n\n$Data_LastSector\n\nw\nY\n" | gptfdisk /dev/rdisk0s1
else
echo -e "d\n2\nn\n\n$New_Data_LastSector\n\nc\n2\nData\nx\na\n2\n48\n49\n\nc\n2\n$Data_GUID\ns\n4\nm\nn\n3\n\n$Data_LastSectorSD\n\nn\n4\n\n$Data_LastSector\n\nw\nY\n" | gptfdisk /dev/rdisk0s1
fi

sleep 1s
newfs_hfs -s -v exploit /dev/rdisk0s1s3
newfs_hfs -s -v bootloader /dev/rdisk0s1s4
sleep 1s
fsck_hfs -f /dev/rdisk0s1s3
fsck_hfs -f /dev/rdisk0s1s4
sleep 2s

### Install exploit_2nd
dd of=/dev/rdisk0s1s3 if=/ramdiskH.dmg bs=512k count=1
sleep 1s
mount_hfs /dev/disk0s1s4 /mnt2

nvram boot-partition=2
nvram boot-ramdisk="/a/b/c/d/e/f/g/h/i/j/k/l/m/disk.dmg"
sleep 1s

if [ $kpatch == 1 ]; then #iOS7_remount_rootfs
mount -u -o rw /
mv -v /iBEC /mnt2/iBEC
else
dd of=/mnt2/iBEC if=/iBEC bs=512k #kpatchless
fi
sleep 1s

### Reboot ###
reboot_
