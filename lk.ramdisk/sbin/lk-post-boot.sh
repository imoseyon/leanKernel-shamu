#!/system/bin/sh

# for lkconfig
[ ! -d "/data/data/leankernel" ] && mkdir /data/data/leankernel
chmod 755 /data/data/leankernel

# init.d support
/system/xbin/busybox run-parts /system/etc/init.d

echo N > /sys/module/cpu_boost/parameters/cpuboost_enable

#
# lkconfig settings below
#

# screen_off_maxfreq
CFILE="/data/data/leankernel/screen_off_maxfreq"
SFILE="/sys/devices/system/cpu/cpufreq"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE/interactive/screen_off_maxfreq

# MMC CRC
CFILE="/data/data/leankernel/use_spi_crc"
SFILE="/sys/module/mmc_core/parameters/use_spi_crc"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# cpu boost
CFILE="/data/data/leankernel/cpuboost_enable"
SFILE="/sys/module/cpu_boost/parameters/cpuboost_enable"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE
