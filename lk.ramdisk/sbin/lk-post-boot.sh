#!/system/bin/sh

# e/frandom permissions
chmod 444 /dev/erandom
chmod 444 /dev/frandom

# allow untrusted apps to read from debugfs
/system/xbin/supolicy --live \
	"allow untrusted_app debugfs file { open read getattr }" \
	"allow untrusted_app sysfs_lowmemorykiller file { open read getattr }" \
	"allow debuggerd gpu_device chr_file { open read getattr }" \
	"allow netd netd capability fsetid" \
	"allow { system_app shell } dalvikcache_data_file file write"

# for lkconfig
[ ! -d "/data/data/leankernel" ] && mkdir /data/data/leankernel
chmod 755 /data/data/leankernel

# init.d support
/system/xbin/busybox run-parts /system/etc/init.d

#
# lkconfig settings below
#

# screen_off_maxfreq
CFILE="/data/data/leankernel/screen_off_maxfreq"
SFILE="/sys/devices/system/cpu/cpufreq/interactive/screen_off_maxfreq"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# MMC CRC
CFILE="/data/data/leankernel/use_spi_crc"
SFILE="/sys/module/mmc_core/parameters/use_spi_crc"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# cpu boost
CFILE="/data/data/leankernel/cpuboost_enable"
SFILE="/sys/module/cpu_boost/parameters/cpuboost_enable"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# charging led
CFILE="/data/data/leankernel/charging_led"
SFILE="/sys/class/leds/charging"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE/trigger && echo 1 > $SFILE/max_brightness

# rgb control
CFILE="/data/data/leankernel/kcal"
SFILE="/sys/devices/platform/kcal_ctrl.0"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE/kcal && echo 1 > $SFILE/kcal_ctrl

# wake gesture control
CFILE="/data/data/leankernel/tsp"
SFILE="/sys/bus/i2c/devices/1-004a/tsp"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE
CFILE="/data/data/leankernel/doubletap2wake"
SFILE="/sys/android_touch/doubletap2wake"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE
CFILE="/data/data/leankernel/sweep2wake"
SFILE="/sys/android_touch/sweep2wake"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE
