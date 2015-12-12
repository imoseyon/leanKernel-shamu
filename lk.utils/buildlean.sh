#!/bin/bash

sdir="/lk2/shamu"
udir="/lk2/shamu/lk.utils"
objdir="/lk2/shamu_obj"
device="shamu"
cc="/data/linaro/49/arm-cortex_a15-linux-gnueabihf-linaro/bin/arm-eabi-"
filename="lk_${device}_m-v${1}.zip"
ocuc_branch="lk-lp-ocuc"
mkbootimg="/data/mkbootimg_tools2/mkboot"

compile() {
  cd $sdir
  sed -i s/CONFIG_LOCALVERSION=\".*\"/CONFIG_LOCALVERSION=\"-leanKernel-${device}-${1}-\"/ $objdir/.config
  make O=$objdir ARCH=arm CROSS_COMPILE=$cc -j4
}

ramdisk() {
  cd $sdir/lk.ramdisk
  chmod 750 init* sbin/adbd* sbin/healthd
  chmod 644 default* uevent* res/images/charger/*
  chmod 755 sbin sbin/lkconfig
  chmod 700 sbin/lk-post-boot.sh
  chmod 755 res res/images res/images/charger
  chmod 640 fstab.shamu
  cd $dir
  $mkbootimg $udir /tmp/boot.img
}

zipit() {
  cd $udir
  cp -f /tmp/boot.img zip/
  cd zip
  zip -r /tmp/$1 *
  rm boot.img
  cd $sdir
} 

cm_ramdisk() {
  cd /tmp/shamu.cm/ramdisk
  cp -a * $sdir/lk.ramdisk
  cd $sdir
  git checkout lk.ramdisk/init.rc lk.ramdisk/init.shamu.rc lk.ramdisk/fstab.shamu
}

[[ $1 =~ "cm" ]] && [[ `git status -s lk.ramdisk` ]] && echo "uncommitted changes in ramdisk!" && exit
[[ $1 =~ "cm" ]] && cm_ramdisk
compile $1 && ramdisk && zipit $filename
[[ $1 =~ "cm" ]] && git checkout HEAD lk.ramdisk && git clean -f lk.ramdisk
