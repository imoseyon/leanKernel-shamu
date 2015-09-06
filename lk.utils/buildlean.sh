#!/bin/bash

sdir="/lk2/shamu"
udir="/lk2/shamu/lk.utils"
objdir="/lk2/shamu_obj"
device="shamu"
cc="/data/linaro/49/arm-cortex_a15-linux-gnueabihf-linaro/bin/arm-eabi-"
filename="lk_${device}_lp-v${1}.zip"

compile() {
  cd $sdir
  sed -i s/CONFIG_LOCALVERSION=\".*\"/CONFIG_LOCALVERSION=\"-leanKernel-${device}-${1}-\"/ $objdir/.config
  make O=$objdir ARCH=arm CROSS_COMPILE=$cc -j4
}

ramdisk() {
  cd $sdir/lk.ramdisk
  chmod 750 init* charger sbin/adbd
  chmod 644 default* uevent* res/images/charger/* lpm.rc
  chmod 755 sbin
  chmod 700 sbin/lk-post-boot.sh
  chmod 755 res res/images res/images/charger
  chmod 640 fstab.shamu
  find . | cpio -o -H newc | gzip > /tmp/ramdisk.img
  /data/mkbootimg_tools/mkbootimg_dtb --kernel $objdir/arch/arm/boot/zImage-dtb  --ramdisk /tmp/ramdisk.img --cmdline "console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=shamu msm_rtb.filter=0x37 ehci-hcd.park=3 utags.blkdev=/dev/block/platform/msm_sdcc.1/by-name/utags utags.backup=/dev/block/platform/msm_sdcc.1/by-name/utagsBackup coherent_pool=8M" --pagesize 2048 -o /tmp/boot.img
}

zipit() {
  cd $udir
  cp -f /tmp/boot.img zip/
  cd zip
  zip -r /tmp/$1 *
  rm boot.img
  cd $sdir
} 

compile $1 && ramdisk && zipit $filename
#compile $1 && ramdisk 
