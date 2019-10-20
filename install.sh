#!/bin/bash
echo "**** s0meiyoshino old installer ****"
## if [ -e "odysseus" ]; then
## echo "Odysseus already exist"
## else
## wget https://dayt0n.github.io/odysseus/odysseus-0.999.zip
## unzip -d ./ odysseus-0.999.zip
## mv -v odysseus-0.999.0 odysseus
## rm odysseus-0.999.zip
## rm -r __MACOSX

## ipsw, idevicerestore, xpwntool from "https://www.dropbox.com/s/oakjm4dgmuutsuf/odysseusOTA-v2.4.zip"
## idevicerestore_old by Odysseus
CC=0
CB=0
DD=0
EE=0

if [ ! -d "src/iPhone5,2/BB" ]; then
    mkdir src/iPhone5,2/BB/
fi

if [ -e "bin/iBoot32Patcher" ]; then
    echo "iBoot32Patcher already exist"
    CC=1
else
    cd iBoot32Patcher
    clang iBoot32Patcher.c finders.c functions.c patchers.c -Wno-multichar -I. -o ../bin/iBoot32Patcher
    cd ..
    if [ -e "bin/iBoot32Patcher" ]; then
        CC=1
    else
        CC=0
    fi
fi

if [ -e "bin/CBPatcher" ]; then
    echo "CBPatcher already exist"
    CB=1
else
    cd CBPatcher
    make
    mv -v CBPatcher ../bin
    cd ..
    if [ -e "bin/CBPatcher" ]; then
        CB=1
    else
        CB=0
    fi
fi


if [ -e "bin/partialZipBrowser" ]; then
    echo "partialZipBrowser already exist"
    DD=1
else
    wget https://github.com/tihmstar/partialZipBrowser/releases/download/v1.0/partialZipBrowser.zip
    unzip -d bin/ partialZipBrowser.zip
    rm -v partialZipBrowser.zip

    if [ -e "bin/partialZipBrowser" ]; then
        DD=1
    else
        DD=0
    fi
fi

if [ -e "src/iPhone5,2/BB/Mav5-8.02.00.Release.bbfw" ]&&[ -e "src/iPhone5,2/BB/Mav5-8.02.00.Release.plist" ]; then
    echo "N42 BBFW (Mav5-8.02.00) already exists"
    EE=1
else
    bin/partialZipBrowser -g Firmware/Mav5-8.02.00.Release.bbfw http://appldnld.apple.com/ios8.4.1/031-31065-20150812-7518F132-3C8F-11E5-A96A-A11A3A53DB92/iPhone5,2_8.4.1_12H321_Restore.ipsw
    bin/partialZipBrowser -g Firmware/Mav5-8.02.00.Release.plist http://appldnld.apple.com/ios8.4.1/031-31065-20150812-7518F132-3C8F-11E5-A96A-A11A3A53DB92/iPhone5,2_8.4.1_12H321_Restore.ipsw
    mv -v Mav5-8.02.00.Release.bbfw src/iPhone5,2/BB/
    mv -v Mav5-8.02.00.Release.plist src/iPhone5,2/BB/
    echo ybHEo3Fv0y/6IYp0X45hxqDY7zM= | base64 --decode > src/iPhone5,2/BB/UniqueBuildID
    echo DJiAwPNNOmT4P9RdlHUt3Q2TTHc= | base64 --decode > src/iPhone5,2/BB/APPSDownloadDigest
    echo x5Xkaqqkc+l3NFLL6s3kAi5P7Sk= | base64 --decode > src/iPhone5,2/BB/APPSHashTableDigest
    echo dFi5J+pSSqOfz31fIvmah2GJO+E= | base64 --decode > src/iPhone5,2/BB/DSP1DownloadDigest
    echo HXUnmGmwIHbVLxkT1rHLm5V6iDM= | base64 --decode > src/iPhone5,2/BB/DSP1HashTableDigest
    echo qtTu6JED2pyocdNVYT1uWN2Back= | base64 --decode > src/iPhone5,2/BB/DSP2DownloadDigest
    echo 2rQ7whhh/WrHPUPMwT5lcsIkYDA= | base64 --decode > src/iPhone5,2/BB/DSP2HashTableDigest
    echo MZ1ERfoeFcbe79pFAl/hbWUSYKc= | base64 --decode > src/iPhone5,2/BB/DSP3DownloadDigest
    echo sKmLhQcjfaOliydm+iwxucr9DGw= | base64 --decode > src/iPhone5,2/BB/DSP3HashTableDigest
    echo 051DfVgeFDI3DC9Hw35HGXCmgkM= | base64 --decode > src/iPhone5,2/BB/RPMDownloadDigest
    echo fAAAAEAQAgDAcZDeGqmO8LWlCHcYIPVjFqR87A== | base64 --decode > src/iPhone5,2/BB/RestoreSBL1PartialDigest
    echo ZAAAAIC9AQACxiFAOjelZm4NtrrLc8bPJIRQNA== | base64 --decode > src/iPhone5,2/BB/SBL1PartialDigest
    echo LycXsLwawICZf2dMjev2yhZs+ic= | base64 --decode > src/iPhone5,2/BB/SBL2DownloadDigest

    if [ -e "src/iPhone5,2/BB/Mav5-8.02.00.Release.bbfw" ]&&[ -e "src/iPhone5,2/BB/Mav5-8.02.00.Release.plist" ]; then
        EE=1
    else
        EE=0
    fi
fi


if [ $CC == 1 ]&&[ $CB == 1 ]&&[ $DD == 1 ]&&[ $EE == 1 ]; then
    echo "Done!"
else
    echo ""
    if [ $CC != 1 ]; then
        echo "Failed install iBoot32Patcher"
    fi
    if [ $CB != 1 ]; then
        echo "Failed install CBPatcher"
    fi
    if [ $DD != 1 ]; then
        echo "Failed install partialZipBrowser"
        echo "Please install it if wget does not exist"
    fi
    if [ $EE != 1 ]; then
        echo "Failed install N42 BB"
        echo "Please try again"
    fi

    echo "Failed install packages!"
fi
