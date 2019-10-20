#!/bin/bash


echo "****************** s0meiyoshino old mode make_ipsw ******************"
echo "** iPhone5,2 iOS 9.x only (legacy mode)"


if [ $# == 1 ]; then
    if [ $1 = "--help" ];then
        echo "**HOW TO USE**"
        echo "./make_ipsw.sh <device model> <downgrade-iOS> <base-iOS> [arg1]"
        echo ""
        echo ""
        echo "[OPTION]"
        echo "  --verbose               : [arg1] Enable verbose boot (for iOS 5 or later)"
        echo "                            *Inject Boot-args=\"-v\" to iBoot."
        echo "  ----csdisable           : [arg1] Inject cs_disable into boot-args"
        echo "                            *Inject Boot-args=\"cs_enforcement_disable=1 amfi_get_out_of_my_way=1\" to iBoot. (for iOS 7 or later)"
        echo "  ----verbose-csdisable   : [arg1] Enable verbose boot and inject cs_disable into boot-args"
        echo "                            *Inject Boot-args \"cs_enforcement_disable=1 amfi_get_out_of_my_way=1 -v\" (for iOS 7 or later)"
        echo "  --jb                    : [arg1] Jailbreak iOS 9.x (iPhone5,2 only) [BETA]"
        echo "                            *This jailbreak is \"UNTETHERED\" jailbreak."
        echo "                            *Untether is provided by iBoot vulnerability."
        echo ""
        echo "[example]"
        echo "./make_ipsw.sh iPhone5,2 9.3.5 7.0.3 --jb"
        echo ""
        echo "[Show detailed help]"
        echo "./make_ipsw.sh --help"
        exit
    fi

fi


if [ $# -lt 3 ]; then
    echo "**HOW TO USE** (iPhone 4 or later)"
    echo "./make_ipsw.sh <device model> <downgrade-iOS> <base-iOS> [arg1]"
    echo ""
    echo "[OPTION] (for iOS 5 or later)"
    echo "  --verbose       : [arg1] Enable verbose boot"
    echo "  --jb            : [arg1] Jailbreak iOS 9.x (iPhone5,2 only)[BETA]"
    echo ""
    echo "[example]"
    echo "./make_ipsw.sh iPhone5,2 9.0.2 7.0.4 --verbose"
    echo ""
    echo "[Show detailed help]"
    echo "./make_ipsw.sh --help"
    echo ""
    exit
fi

Remove_Exploit=0
jailbreak=0

echo ""
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!  WARNING  !!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!This tool uses iOS 7 iBoot vulnerability. USE AT YOUR OWN RISK !!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo ""

if [ $# == 4 ]; then
    if [ $4 != "--verbose" ] && [ $4 != "--jb" ] &&  [ $4 != "----csdisable" ] && [ $4 != "----verbose-csdisable" ]; then
        echo "[ERROR] Invalid argument"
        exit
    fi

    if [ $4 = "--remove" ]; then
        Remove_Exploit=1
    fi

    if [ $4 = "--jb" ]; then
        jailbreak=1
    fi

fi

if [ $# -gt 4 ]; then
    echo "[ERROR] Too many arguments"
    exit
fi

Identifier=0
InternalName=0
iBootInternalName=0
SoC=0
Image=0
BaseFWVer=0
BaseFWBuild=0
Size=0
Chip=0
expdisk=-1

#### Set support device information ####
if [ $1 = "iPhone5,2" ]; then
    if [ $3 = "7.0" ] || [ $3 = "7.0.2" ] || [ $3 = "7.0.3" ] || [ $3 = "7.0.4" ] || [ $3 = "7.0.6" ]; then
        Identifier="iPhone5,2"
        InternalName="n42ap"
        iBootInternalName="n42ap"
        SoC="s5l8950x"
        Image="1136~iphone-lightning"
        Size="1136"
        Chip="A6"
        expdisk=0
        if [ $3 = "7.0" ]; then
            BaseFWVer="7.0"
            BaseFWBuild="11A465"
        fi
        if [ $3 = "7.0.2" ]; then
            BaseFWVer="7.0.2"
            BaseFWBuild="11A501"
        fi
        if [ $3 = "7.0.3" ]; then
            BaseFWVer="7.0.3"
            BaseFWBuild="11B511"
        fi
        if [ $3 = "7.0.4" ]; then
            BaseFWVer="7.0.4"
            BaseFWBuild="11B554a"
        fi
        if [ $3 = "7.0.6" ]; then
            BaseFWVer="7.0.6"
            BaseFWBuild="11B651"
        fi
    fi

    if [ $3 = "7.1" ] || [ $3 = "7.1.1" ] || [ $3 = "7.1.2" ]; then
        Identifier="iPhone5,2"
        InternalName="n42ap"
        iBootInternalName="n42ap"
        SoC="s5l8950x"
        Image="1136~iphone-lightning"
        Size="1136"
        Chip="A6"
        expdisk=1
        if [ $3 = "7.1" ]; then
            BaseFWVer="7.1"
            BaseFWBuild="11D167"
        fi
        if [ $3 = "7.1.1" ]; then
            BaseFWVer="7.1.1"
            BaseFWBuild="11D201"
        fi
        if [ $3 = "7.1.2" ]; then
            BaseFWVer="7.1.2"
            BaseFWBuild="11D257"
        fi
        if [ $InternalName != "n42ap" ]; then
            echo "[ERROR] This base-iOS is NOT supported!"
            exit
        fi
    fi
fi

if [ $Identifier == 0 ]; then
    echo "[ERROR] This device is NOT supported!!"
    exit
fi

EXPLOITBUILD=0
if [ $expdisk == 0 ]; then
EXPLOITBUILD="11B554a"
fi
if [ $expdisk == 1 ]; then
EXPLOITBUILD="11D257"
fi

#### Find base firmware ####
if [ -e ""$Identifier"_"$BaseFWVer"_"$BaseFWBuild"_Restore.ipsw" ]; then
    echo ""$Identifier"_"$BaseFWVer"_"$BaseFWBuild"_Restore.ipsw OK"
else
    echo ""$Identifier"_"$BaseFWVer"_"$BaseFWBuild"_Restore.ipsw does not exist"
    exit
fi

#### Set macOS version ####
OSXVer=`sw_vers -productVersion | awk -F. '{print $2}'`
DD=0
JB=0
disablekaslr=0
sbops_patch=0
iBoot9=0
DeveloperBeta=0
pangu9=0
iBoot9_Partition_patch="0"
iBoot_KASLR="0"
iOSLIST=0

BundleType="Down"
# BundleType == Down; Base on odysseus bundle
# BundleType == New; Base on s0meiyoshino custom bundle

#### iPhone 4 ####
#### iPhone 4s [BETA] ####
#### iPhone 5 (Global) ####
if [ $Identifier = "iPhone5,2" ]; then

  if [ $2 = "9.0" ] || [ $2 = "9.0.1" ] || [ $2 = "9.0.2" ] || [ $2 = "9.1" ] || [ $2 = "9.2" ] || [ $2 = "9.2.1" ] || [ $2 = "9.3" ] || [ $2 = "9.3r" ] || [ $2 = "9.3.1" ] || [ $2 = "9.3.2" ] || [ $2 = "9.3.3" ] || [ $2 = "9.3.4" ] || [ $2 = "9.3.5" ]; then
  iOSLIST=7
  iBootInternalName="n42"
  iBoot9=1

  if [ $jailbreak == 1 ]; then
   JB=1
   sbops_patch=0
  fi
  if [ $jailbreak == 0 ]; then
   sbops_patch=1
  fi

  if [ $2 = "9.0" ] || [ $2 = "9.0.1" ] || [ $2 = "9.0.2" ]; then
   pangu9=1
  fi

  if [ $2 = "9.0" ] || [ $2 = "9.0.1" ] || [ $2 = "9.0.2" ] || [ $2 = "9.1" ] || [ $2 = "9.2" ] || [ $2 = "9.2.1" ]; then
   Boot_Partition_Patch="0000b12: 00200020"
   Boot_Ramdisk_Patch="0000c0a: 00200020"
   if [ $2 = "9.0" ] || [ $2 = "9.0.1" ] || [ $2 = "9.0.2" ] || [ $2 = "9.1" ]; then
    iBoot9_Partition_Patch="00013f0: 3392f3bf"
   fi
   if [ $2 = "9.2" ] || [ $2 = "9.2.1" ]; then
    iBoot9_Partition_Patch="00013f0: c392f3bf"
   fi
  fi

  if [ $2 = "9.3" ] || [ $2 = "9.3r" ] || [ $2 = "9.3.1" ] || [ $2 = "9.3.2" ] || [ $2 = "9.3.3" ] || [ $2 = "9.3.4" ] || [ $2 = "9.3.5" ]; then
   Boot_Partition_Patch="0000b1e: 00200020"
   Boot_Ramdisk_Patch="0000c16: 00200020"
   iBoot9_Partition_Patch="0001400: 439af3bf"
  fi

    if [ $2 = "9.0" ]; then
        #### iOS 9.0 ####
        iOSVersion="9.0_13A344"
        iOSBuild="13A344"
        RestoreRamdisk="058-03706-363.dmg"
        iBoot_IV="547e2505ec2c8b0517fad1d308b6abc8"
        iBoot_Key="8667fe328a7dd41fde7dd8b34919718b99143638679c82431a621bb2143ea078"
        BundleType="New"
    fi

    if [ $2 = "9.0.1" ]; then
        #### iOS 9.0.1 ####
        iOSVersion="9.0.1_13A404"
        iOSBuild="13A404"
        RestoreRamdisk="058-03706-367.dmg"
        iBoot_IV="ca6241f72e6d34ba923f15faf86d0dbf"
        iBoot_Key="cdaefe386c1fc8adc896c7b6088202dfb8b8c0d06042b1bd383e351584e2868f"
        BundleType="New"
    fi

    if [ $2 = "9.0.2" ]; then
        #### iOS 9.0.2 ####
        iOSVersion="9.0.2_13A452"
        iOSBuild="13A452"
        RestoreRamdisk="058-03706-369.dmg"
        iBoot_IV="23b4fc8e6f8b6aa20e8ab2380b3ee542"
        iBoot_Key="b6a0fecaf54e3ebe46c670e74f92f053433f2b7b32d33453b5dbf75b3bdfe612"
    fi

    if [ $2 = "9.1" ]; then
        #### iOS 9.1 ####
        iOSVersion="9.1_13B143"
        iOSBuild="13B143"
        RestoreRamdisk="058-25124-078.dmg"
        iBoot_IV="4a89aa4c72bf5a6128738f9447f8c6f7"
        iBoot_Key="08a8b399604b3f0a645499da9ced989c0286393e2c8d2fcea197fbe4891e1b6d"
        BundleType="New"
    fi

    if [ $2 = "9.2" ]; then
        #### iOS 9.2 ####
        iOSVersion="9.2_13C75"
        iOSBuild="13C75"
        RestoreRamdisk="058-25952-079.dmg"
        iBoot_IV="809117c933e30063fdbef74484af8f6d"
        iBoot_Key="43dd2a62ca1bc2ab9dd80237f65d0fcc345bfa8b4b687126974c292fed7de455"
        BundleType="New"
    fi

    if [ $2 = "9.2.1" ]; then
        #### iOS 9.2.1 ####
        iOSVersion="9.2.1_13D15"
        iOSBuild="13D15"
        RestoreRamdisk="058-32359-015.dmg"
        iBoot_IV="13420d70c4af0e7c796a66f611889b2f"
        iBoot_Key="c10a16bb567e8e96db7162d44cd666e513df771a9742371f4f84466ad44fd25a"
        BundleType="New"
    fi

    if [ $2 = "9.3" ]; then
        #### iOS 9.3 ####
        iOSVersion="9.3_13E233"
        iOSBuild="13E233"
        RestoreRamdisk="058-25481-331.dmg"
        iBoot_IV="196a1583b56587544d11b931f0c0774a"
        iBoot_Key="c1c36ffd890e23a9774b9ce717bfc0e37ed9b6cd8534e61d1ad0b4472caa61d1"
        BundleType="New"
    fi

    if [ $2 = "9.3r" ]; then
        #### iOS 9.3 ####
        iOSVersion="9.3_13E237"
        iOSBuild="13E237"
        RestoreRamdisk="058-25481-332.dmg"
        iBoot_IV="196a1583b56587544d11b931f0c0774a"
        iBoot_Key="c1c36ffd890e23a9774b9ce717bfc0e37ed9b6cd8534e61d1ad0b4472caa61d1"
        BundleType="New"
    fi

    if [ $2 = "9.3.1" ]; then
        #### iOS 9.3.1 ####
        iOSVersion="9.3.1_13E238"
        iOSBuild="13E238"
        RestoreRamdisk="058-25481-333.dmg"
        iBoot_IV="196a1583b56587544d11b931f0c0774a"
        iBoot_Key="c1c36ffd890e23a9774b9ce717bfc0e37ed9b6cd8534e61d1ad0b4472caa61d1"
        BundleType="New"
    fi

    if [ $2 = "9.3.2" ]; then
        #### iOS 9.3.2 ####
        iOSVersion="9.3.2_13F69"
        iOSBuild="13F69"
        RestoreRamdisk="058-37546-072.dmg"
        iBoot_IV="9ff772c17dd807f771fc53f6542fafb6"
        iBoot_Key="3341eef99ca9cd617f767b83cb02dde368eef0a18e87480cea53efc5b39fd954"
        BundleType="New"
    fi

    if [ $2 = "9.3.3" ]; then
        #### iOS 9.3.3 ####
        iOSVersion="9.3.3_13G34"
        iOSBuild="13G34"
        RestoreRamdisk="058-49199-034.dmg"
        iBoot_IV="bfc2716df03cabc915daa041bc0b0865"
        iBoot_Key="5705c05a5872b903b234edbee2fb75b42fa7ee7b26176f1b79eb2a398f2dbddb"
        BundleType="New"
    fi

    if [ $2 = "9.3.4" ]; then
        #### iOS 9.3.4 ####
        iOSVersion="9.3.4_13G35"
        iOSBuild="13G35"
        RestoreRamdisk="058-49199-035.dmg"
        iBoot_IV="7ff8a2334f4594dd52a130a8e1e8b6b2"
        iBoot_Key="9a6a8533a01050926af980cdeada174678745487abf9dea019c97e6e8f662f5f"
        BundleType="New"
    fi

    if [ $2 = "9.3.5" ]; then
        #### iOS 9.3.5 ####
        iBoot_KASLR="001a1fa: 00bf002100bf"
        iOSVersion="9.3.5_13G36"
        iOSBuild="13G36"
        RestoreRamdisk="058-49199-036.dmg"
        iBoot_IV="7d7d25b9f8d6d3ea15195f97f429e76e"
        iBoot_Key="d958a3bfdf81fc24114183eec0c1a1e994723772129b5719efad04e504c06f08"
    fi
  fi

fi

if [ $iOSLIST == 0 ]; then
    echo "[ERROR] This downgrade-iOS is NOT supported!"
    exit
fi

if [ $jailbreak == 1 ]; then
    if [ $JB != 1 ]; then
        echo "[ERROR] This version is NOT supported jailbreak!"
        exit
    fi
fi

### look ipsw??
if [ -e ""$Identifier"_"$iOSVersion"_Restore.ipsw" ]; then
    echo ""$Identifier"_"$iOSVersion"_Restore.ipsw OK"
else
    echo ""$Identifier"_"$iOSVersion"_Restore.ipsw does not exist"
    exit
fi

if [ -d "tmp_ipsw" ]; then
    rm -r tmp_ipsw
fi

echo ""

mkdir tmp_ipsw
cd tmp_ipsw

#### Decrypt iBoot ####
unzip -j ../"$Identifier"_"$iOSVersion"_Restore.ipsw "Firmware/all_flash/all_flash."$InternalName".production/iBoot."$iBootInternalName".RELEASE.img3"
../bin/xpwntool iBoot."$iBootInternalName".RELEASE.img3 iBoot."$iBootInternalName".dec.img3 -k $iBoot_Key -iv $iBoot_IV -decrypt
../bin/xpwntool iBoot."$iBootInternalName".dec.img3 iBoot."$iBootInternalName".dec
echo ""

if [ $iOSLIST != 4 ]; then
    #### Patching iBoot5/6/7 ####
    if [ $# -lt 4 ]; then
        ../bin/iBoot32Patcher iBoot."$iBootInternalName".dec PwnediBoot."$iBootInternalName".dec -r
    fi

    if [ $# == 4 ]; then
        if [ $4 = "--verbose" ]; then
            ../bin/iBoot32Patcher iBoot."$iBootInternalName".dec PwnediBoot."$iBootInternalName".dec -r -b "-v"
        fi

        if [ $4 = "----csdisable" ]; then
            if [ $iOSLIST == 5 ]||[ $iOSLIST == 6 ]; then
                ../bin/iBoot32Patcher iBoot."$iBootInternalName".dec PwnediBoot."$iBootInternalName".dec -r -d -b "cs_enforcement_disable=1 amfi=0xff"
            fi
            if [ $iOSLIST == 7 ]; then
                ../bin/iBoot32Patcher iBoot."$iBootInternalName".dec PwnediBoot."$iBootInternalName".dec -r -d -b "cs_enforcement_disable=1 amfi_get_out_of_my_way=1"
            fi
        fi

        if [ $4 = "----verbose-csdisable" ]; then
            if [ $iOSLIST == 5 ]||[ $iOSLIST == 6 ]; then
                ../bin/iBoot32Patcher iBoot."$iBootInternalName".dec PwnediBoot."$iBootInternalName".dec -r -d -b "cs_enforcement_disable=1 amfi=0xff -v"
            fi
            if [ $iOSLIST == 7 ]; then
                ../bin/iBoot32Patcher iBoot."$iBootInternalName".dec PwnediBoot."$iBootInternalName".dec -r -d -b "cs_enforcement_disable=1 amfi_get_out_of_my_way=1 -v"
            fi
        fi

        if [ $jailbreak == 1 ]; then
            ../bin/iBoot32Patcher iBoot."$iBootInternalName".dec PwnediBoot."$iBootInternalName".dec -r -d -b "cs_enforcement_disable=1 amfi_get_out_of_my_way=1 -v"
            echo "$iBoot_KASLR" | xxd -r - PwnediBoot."$iBootInternalName".dec
        fi
    fi

    echo "$Boot_Partition_Patch" | xxd -r - PwnediBoot."$iBootInternalName".dec
    if [ $Identifier != "iPhone3,1" ]; then
        echo "$Boot_Ramdisk_Patch" | xxd -r - PwnediBoot."$iBootInternalName".dec
        if [ $iOSLIST == 5 ]||[ $iOSLIST == 6 ]; then
            ../bin/iBoot32Patcher PwnediBoot."$iBootInternalName".dec PwnediBoot2."$iBootInternalName".dec -r
            rm PwnediBoot."$iBootInternalName".dec
            mv PwnediBoot2."$iBootInternalName".dec PwnediBoot."$iBootInternalName".dec
        fi

        if [ $iBoot9 == 1 ]; then
            echo "$iBoot9_Partition_Patch" | xxd -r - PwnediBoot."$iBootInternalName".dec
        fi
    fi

    ../bin/xpwntool PwnediBoot."$iBootInternalName".dec PwnediBoot."$iBootInternalName".img3 -t iBoot."$iBootInternalName".dec.img3
    echo "0000010: 63656269" | xxd -r - PwnediBoot."$iBootInternalName".img3
    echo "0000020: 63656269" | xxd -r - PwnediBoot."$iBootInternalName".img3
    mv -v PwnediBoot."$iBootInternalName".img3 iBEC
    tar -cvf bootloader.tar iBEC
fi

cd ../

#### Make custom ipsw by odysseus ####
if [ $Chip != "A4" ]&&[ $JB != 1 ]; then
    ./bin/ipsw "$Identifier"_"$iOSVersion"_Restore.ipsw tmp_ipsw/"$Identifier"_"$iOSVersion"_Odysseus.ipsw -bbupdate -memory
fi

if [ $Identifier = "iPhone5,2" ]&&[ $JB == 1 ]; then
    ./bin/ipsw "$Identifier"_"$iOSVersion"_Restore.ipsw tmp_ipsw/"$Identifier"_"$iOSVersion"_Odysseus.ipsw -bbupdate -memory src/jb9/packages.tar
fi

#### Confirm existence of firmware ####
if [ -e "tmp_ipsw/"$Identifier"_"$iOSVersion"_Odysseus.ipsw" ]; then
    echo "success"
else
    echo "[ERROR] failed make ipsw"
    exit
fi

#### Make CFW ####
cd tmp_ipsw

mkdir BaseFWBuild
unzip -j ../"$Identifier"_"$BaseFWVer"_"$BaseFWBuild"_Restore.ipsw "Firmware/all_flash/all_flash."$InternalName".production/*" -d BaseFWBuild

mkdir $iOSBuild
unzip -d $iOSBuild "$Identifier"_"$iOSVersion"_Odysseus.ipsw

if [ $iOSLIST == 7 ]; then
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin@"$Image"."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$iBootInternalName".RELEASE.img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$iBootInternalName".RELEASE.img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode@"$Image"."$SoC".img3
    mv -v BaseFWBuild/applelogo@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/batterycharging0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/batterycharging1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/batteryfull@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/batterylow0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/batterylow1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/glyphplugin@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/iBoot."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$iBootInternalName".RELEASE.img3
    mv -v BaseFWBuild/LLB."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$iBootInternalName".RELEASE.img3
    mv -v BaseFWBuild/recoverymode@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
fi

if [ $Identifier = "iPhone5,2" ]; then
    ## iPhone5,2 BB=8.02.00 (8.4.1 full OTA)
    /usr/libexec/PlistBuddy -c "Import BuildIdentities:0:UniqueBuildID ../src/iPhone5,2/BB/UniqueBuildID" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:APPS-DownloadDigest ../src/iPhone5,2/BB/APPSDownloadDigest" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:APPS-HashTableDigest ../src/iPhone5,2/BB/APPSHashTableDigest" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:DSP1-DownloadDigest ../src/iPhone5,2/BB/DSP1DownloadDigest" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:DSP1-HashTableDigest ../src/iPhone5,2/BB/DSP1HashTableDigest" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:DSP2-DownloadDigest ../src/iPhone5,2/BB/DSP2DownloadDigest" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:DSP2-HashTableDigest ../src/iPhone5,2/BB/DSP2HashTableDigest" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:DSP3-DownloadDigest ../src/iPhone5,2/BB/DSP3DownloadDigest" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:DSP3-HashTableDigest ../src/iPhone5,2/BB/DSP3HashTableDigest" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:RPM-DownloadDigest ../src/iPhone5,2/BB/RPMDownloadDigest" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:RestoreSBL1-PartialDigest ../src/iPhone5,2/BB/RestoreSBL1PartialDigest" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:SBL1-PartialDigest ../src/iPhone5,2/BB/SBL1PartialDigest" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:SBL2-DownloadDigest ../src/iPhone5,2/BB/SBL2DownloadDigest" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "set BuildIdentities:0:Manifest:BasebandFirmware:RestoreSBL1-Version "-1559152312"" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "set BuildIdentities:0:Manifest:BasebandFirmware:SBL1-Version "-1560200888"" $iOSBuild/BuildManifest.plist
    /usr/libexec/PlistBuddy -c "set BuildIdentities:0:Manifest:BasebandFirmware:Info:Path "Firmware/Mav5-8.02.00.Release.bbfw"" $iOSBuild/BuildManifest.plist

    cp -a -v ../src/iPhone5,2/BB/Mav5-8.02.00.Release.bbfw $iOSBuild/Firmware
    cp -a -v ../src/iPhone5,2/BB/Mav5-8.02.00.Release.plist $iOSBuild/Firmware
fi

### iPhone5,2_12H321_OTA ###
#BuildIdentities:0:UniqueBuildID    ybHEo3Fv0y/6IYp0X45hxqDY7zM=

#BuildIdentities:0:Manifest:BasebandFirmware:
#APPS-DownloadDigest                DJiAwPNNOmT4P9RdlHUt3Q2TTHc=
#APPS-HashTableDigest               x5Xkaqqkc+l3NFLL6s3kAi5P7Sk=
#DSP1-DownloadDigest                dFi5J+pSSqOfz31fIvmah2GJO+E=
#DSP1-HashTableDigest               HXUnmGmwIHbVLxkT1rHLm5V6iDM=
#DSP2-DownloadDigest                qtTu6JED2pyocdNVYT1uWN2Back=
#DSP2-HashTableDigest               2rQ7whhh/WrHPUPMwT5lcsIkYDA=
#DSP3-DownloadDigest                MZ1ERfoeFcbe79pFAl/hbWUSYKc=
#DSP3-HashTableDigest               sKmLhQcjfaOliydm+iwxucr9DGw=
#RPM-DownloadDigest                 051DfVgeFDI3DC9Hw35HGXCmgkM=
#RestoreSBL1-PartialDigest          fAAAAEAQAgDAcZDeGqmO8LWlCHcYIPVjFqR87A==
#RestoreSBL1-Version                -1559152312
#SBL1-PartialDigest                 ZAAAAIC9AQACxiFAOjelZm4NtrrLc8bPJIRQNA==
#SBL1-Version                       -1560200888
#SBL2-DownloadDigest                LycXsLwawICZf2dMjev2yhZs+ic=
#Info:Path                          Firmware/Mav5-8.02.00.Release.bbfw

if [ $Identifier = "iPhone5,2" ]&&[ $disablekaslr == 1 ]; then
    echo $iBEC_KASLR | xxd -r - $iOSBuild/Firmware/dfu/iBEC.n42.RELEASE.dfu ## N42-iOS 8.0.2
fi

if [ $# == 4 ]; then
    if [ $Identifier = "iPhone5,2" ]&&[ $jailbreak == 1 ]; then
        ../bin/xpwntool $iOSBuild/Downgrade/kernelcache.release.n42 $iOSBuild/kernelcache.release.dec
        ## kernelpacth by CBPatcher
        #bspatch $iOSBuild/kernelcache.release.dec $iOSBuild/pwnkernelcache.release.dec ../FirmwareBundles/"$BundleType"_"$Identifier"_"$iOSVersion".bundle/kernelcache.patch
        if [ $2 = "9.3r" ];then
            ../bin/CBPatcher $iOSBuild/kernelcache.release.dec $iOSBuild/pwnkernelcache.release.dec 9.3
        else
            ../bin/CBPatcher $iOSBuild/kernelcache.release.dec $iOSBuild/pwnkernelcache.release.dec "$2"
        fi
        mv -v $iOSBuild/Downgrade/kernelcache.release.n42 $iOSBuild/Downgrade/kernelcache.release.n42_
        ../bin/xpwntool $iOSBuild/pwnkernelcache.release.dec $iOSBuild/Downgrade/kernelcache.release.n42 -t $iOSBuild/Downgrade/kernelcache.release.n42_
        rm $iOSBuild/Downgrade/kernelcache.release.n42_
        rm $iOSBuild/kernelcache.release.n42
        cp -a -v $iOSBuild/Downgrade/kernelcache.release.n42 $iOSBuild/kernelcache.release.n42
        rm $iOSBuild/pwnkernelcache.release.dec
        rm $iOSBuild/kernelcache.release.dec
    fi
fi

if [ $Identifier = "iPhone5,2" ]&&[ $sbops_patch == 1 ]; then
    ../bin/xpwntool $iOSBuild/Downgrade/kernelcache.release.n42 $iOSBuild/Downgrade/kernelcache.release.dec
    bspatch $iOSBuild/Downgrade/kernelcache.release.dec $iOSBuild/Downgrade/pwnkernelcache.release.dec ../FirmwareBundles/"$BundleType"_"$Identifier"_"$iOSVersion".bundle/sbops.patch
    mv -v $iOSBuild/Downgrade/kernelcache.release.n42 $iOSBuild/Downgrade/kernelcache.release.n42_
    ../bin/xpwntool $iOSBuild/Downgrade/pwnkernelcache.release.dec $iOSBuild/Downgrade/kernelcache.release.n42 -t $iOSBuild/Downgrade/kernelcache.release.n42_

    rm $iOSBuild/Downgrade/kernelcache.release.n42_
    rm $iOSBuild/Downgrade/pwnkernelcache.release.dec
    rm $iOSBuild/Downgrade/kernelcache.release.dec
fi

#### make ramdisk ####
../bin/xpwntool $iOSBuild/$RestoreRamdisk $iOSBuild/ramdisk.dmg
if [ -e ""$iOSBuild"/ramdisk.dmg" ]; then
    echo "OK"
else
    echo "[ERROR] failed mount restore ramdisk"
    exit
fi

hdiutil resize $iOSBuild/ramdisk.dmg -size 30m
#n90 8l1     : 25 MB
#n90 9B176   : 17 MB
#n90 10B146  : 10 MB
#n42 13a452  : 21 MB
#n42 14A5261v: 24 MB


hdiutil attach -mountpoint ramdisk/ $iOSBuild/ramdisk.dmg
sleep 1s


tar -xvf bootloader.tar -C ramdisk/ --preserve-permissions


if [ $iOSLIST != 4 ]; then #NEW
    tar -xvf ../src/"$Identifier"/bin.tar -C ramdisk/ --preserve-permissions
    mv -v ramdisk/sbin/reboot ramdisk/sbin/reboot_

    if [ $pangu9 == 1 ]; then #iOS 9.0-9.0.2
        cp -a -v ../src/"$Identifier"/"$EXPLOITBUILD"/partition_pg9.sh ramdisk/sbin/reboot
    fi

    if [ $iOSLIST != 5 ]&&[ $pangu9 != 1 ]; then
        cp -a -v ../src/"$Identifier"/"$EXPLOITBUILD"/partition.sh ramdisk/sbin/reboot
    fi

    cp -a -v ../src/"$Identifier"/"$EXPLOITBUILD"/ramdiskH.dmg ramdisk/ #exploit

    chmod 755 ramdisk/sbin/reboot
fi

if [ $iOSLIST == 7 ]; then
    mv -v ramdisk/usr/share/progressui/applelogo@2x.tga ramdisk/usr/share/progressui/applelogo_orig.tga
    bspatch ramdisk/usr/share/progressui/applelogo_orig.tga ramdisk/usr/share/progressui/applelogo@2x.tga ../patch/applelogo7.patch
fi

if [ $jailbreak == 1 ]; then
    rm ramdisk/sbin/reboot
    cp -a -v ../src/"$Identifier"/"$EXPLOITBUILD"/jb9/partition.sh ramdisk/sbin/reboot
    mkdir ramdisk/jb
    cp -a -v ../src/jb9/fstab ramdisk/jb
    chmod 755 ramdisk/sbin/reboot
fi

sleep 1s

hdiutil detach ramdisk/
sleep 1s

mv $iOSBuild/$RestoreRamdisk $iOSBuild/t.dmg
../bin/xpwntool $iOSBuild/ramdisk.dmg $iOSBuild/$RestoreRamdisk -t $iOSBuild/t.dmg
rm $iOSBuild/ramdisk.dmg
rm $iOSBuild/t.dmg

rm -r BaseFWBuild

#### zipping ipsw ####
cd $iOSBuild
zip ../../"$Identifier"_"$iOSVersion"_Custom.ipsw -r0 *

#### clean up ####
cd ../../
rm -r tmp_ipsw

#### Done ####
echo "Done!"
