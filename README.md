# s0meiyoshino old  
  
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
### iPhone 5 (iPhone5,2)  
For iPhone 5, SHSH of either iOS 7.x is required.  
- Downgrade and untethered jailbreak  
    - iOS 9 : 9.0-9.3.5  
    - iOS 10: 10.3.3  
  
The bundle is provided from https://github.com/dora2-iOS/xpwn/tree/master/ipsw-patch/FirmwareBundles  
  
## How to use  
1. Download IPSW (https://ipsw.me)  
2. Prepare put it firmware (base-ipsw, downgrade-ver-ipsw) in s0meiyoshino.  
  
3. Install packages  
> ./install.sh  
  
4. make ipsw  
> ./make_ipsw.sh [device model] [downgrade-iOS] [base-iOS] [args]  
  
## Restore (iPhone 5)  
First, put shsh of 7.x in the shsh/ directory.  
And, change shsh file name. If you want to downgrade to 6.1.4 on iPhone 5 (Global), it will be as follows.  
> [ECID]-iPhone5,2-7.0.x.shsh -> [ECID]-iPhone5,2-6.1.4.shsh  
  
Next, put in device "kDFU mode" or "Pwned recovery mode".  
Then, execute the following.  
> bin/idevicerestore -e -w [CUSTOM_IPSW]  
  
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
daytonhasty for Odysseus  
libimobiledev for idevicerestore  
planetbeing for xpwn  
 
