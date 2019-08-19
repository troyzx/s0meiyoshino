# s0meiyoshino v4.0 beta 5  
  
## Warning  
 his tool enables exploit of iBoot.  
 Therefore your device can be attacked from iBoot.  
 If you have a blob, downgrade it using it is much safer.  
 In the case of iPhone 4, it does not matter because it is already pwned by Bootrom vulnerability.  
  
## Request  
- OS X (macOS) 10.10.5 - 10.13.6 (-10.14??15??)  
- 10 GB of free space  
- wget  
  
## Supported version  
### iPhone 3GS (iPhone2,1)  
- Downgrade only  
    - iPhoneOS 3: 3.0  
    - iOS 4: --  
    - iOS 5: --  
    - iOS 6: 6.1.6  
  
### iPhone 4 (iPhone3,1)  
- Downgrade only  
    - iOS 4: 4.3.3-4.3.5  
Downgrade method below 4.3.3: https://diosra2.hatenadiary.jp/entry/20190619/1560873405  
    - iOS 5: 5.1.1[9B206]  
    - iOS 6: 6.0-6.1.3  
    - iOS 7: 7.0-7.1.2  
  
### iPhone 4s (iPhone4,1)  
For iPhone 5, SHSH of either iOS 7.1.x is required.  
But, downgrade target SHSH is unnecessary!  
- Downgrade only  
    - iOS 5 : 5.1.1  
    - iOS 6 : 6.1.3  
    - iOS 7: 7.1.2  
  
### iPhone 5 (iPhone5,1)  
For iPhone 5, SHSH of either iOS 7.x is required.  
But, downgrade target SHSH is unnecessary!  
- Downgrade only  
    - iOS 6 : 6.1.4  
    - iOS 7 : 7.1.2  
  
### iPhone 5 (iPhone5,2)  
For iPhone 5, SHSH of either iOS 7.x is required.  
But, downgrade target SHSH is unnecessary!  
- Downgrade only  
    - iOS 6 : 6.0-6.1.2, 6.1.4  
    - iOS 7 : 7.0-7.1.2  
    - iOS 8 : 8.0.2  
- Downgrade and untethered jailbreak  
    - iOS 9 : 9.0-9.3.5  
    - iOS 10: 10.3.3  
  
The bundle is provided from https://github.com/dora2-iOS/xpwn/tree/master/ipsw-patch/FirmwareBundles  
  
## How to use (iPhone 3GS)  
1. Download IPSW (https://ipsw.me)  
2. Prepare put it firmware (downgrade-ver-ipsw) in s0meiyoshino.  
  
3. Make CFW  
> ./make_ipsw.sh iPhone2,1 [downgrade-iOS] [Bootrom version]  
  
4. Restore  
Put in device "DFU mode".  
after, run sh  
> ./restore3gs.sh  
  
## How to use  
1. Download IPSW (https://ipsw.me)  
2. Prepare put it firmware (base-ipsw, downgrade-ver-ipsw) in s0meiyoshino.  
  
3. Install packages  
> ./install.sh  
  
4. make ipsw  
> ./make_ipsw.sh [device model] [downgrade-iOS] [base-iOS] [args]  
  
## Restore (iPhone 4)  
First, put in device "DFU mode".  
Then, execute the following.  
> ./restore4.sh  
  
## Restore (iPhone 5)  
First, put shsh of 7.x in the shsh/ directory.  
And, change shsh file name. If you want to downgrade to 6.1.4 on iPhone 5 (Global), it will be as follows.  
> [ECID]-iPhone5,2-7.0.x.shsh -> [ECID]-iPhone5,2-6.1.4.shsh  
  
Next, put in device "kDFU mode" or "Pwned recovery mode".  
Then, execute the following.  
> bin/idevicerestore -e -w [CUSTOM_IPSW]  
  
## How to delete exploit (iPhone 4)  
This method adds "boot-partition=2" to the nvram variable.  
Even if you restore it with OFW in iTunes, it will be in recovery mode as it is.  
  
It can be deleted in the following way.  
1. Make Remove Custom Firmware [./make_ipsw.sh iPhone3,1 7.1.2 7.1.2 --remove]  
2. Restore using RCFW  
  
## How to delete exploit (iPhone 5)  
This method adds "boot-partition", and "boot-ramdisk" to the nvram variable.  
However, since iOS 9 and later ignore this, if you want to restore it, do as follows.  
1. Restore iOS 9.0 - 10.3.3  
2. Jailbreak  
3. Execution command "nvram -d boot-ramdisk"  
4. Reboot  
  
## Credit  
xerub for De Rebus Antiquis  
danzatt for ios-dualboot(hfs_resize etc.)  
Roderick W. Smith - for gptfdisk  
iH8sn0w for iBoot32Patcher  
tihmstar for Improvement of iBoot32Patcher, partialZipBrowser  
nyan_satan for Improvement of iBoot32Patcher, TwistedMind2  
ShadowLee19 for bypass boot-partition and boot-ramdisk value iBoot patch  
JonathanSeals for CBPatcher, disable kaslr patch, and many tips  
Benfxmth for bypass reset boot-partition value iBoot patch, and many tips  
alitek123 for many Odysseus Bundles  
nyanko_kota for tester on iPhone 4s  
winocm for opensn0w  
daytonhasty for Odysseus  
libimobiledev for idevicerestore  
planetbeing for xpwn  
axi0mX for ipwndfu, alloc8 exploit  
posixninja and pod2g for SHAtter exploit  
iPhone Dev Team for 0x24000 Segment Overflow  
