#!/bin/bash

sdir="/lk2/shamu"
udir="/lk2/shamu/lk.utils"
objdir="/lk2/shamu_obj"
device="shamu"
cc="/data/linaro/49/arm-cortex_a15-linux-gnueabihf-linaro/bin/arm-eabi-"
filename="lk_${device}_lp-v${1}.zip"
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
  cd /tmp/cm/ramdisk
  cp init sepolicy init.cm.rc init.environ.rc init.superuser.rc *_contexts $sdir/lk.ramdisk
  cd $sdir
}

[[ $1 =~ "cm" ]] && cm_ramdisk && sed -i '/SYSTEMSERVERCLASSPATH \/system\/framework\/services/d' lk.ramdisk/init.lk.rc
[[ $1 =~ "ocuc" ]] && git checkout $ocuc_branch arch/arm/boot/dts/qcom/apq8084.dtsi drivers/thermal/lk_thermal.h
compile $1 && ramdisk && zipit $filename
[[ $1 =~ "ocuc" ]] && git checkout HEAD arch/arm/boot/dts/qcom/apq8084.dtsi drivers/thermal/lk_thermal.h
[[ $1 =~ "cm" ]] && git checkout HEAD lk.ramdisk
