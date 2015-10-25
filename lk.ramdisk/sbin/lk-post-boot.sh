#!/system/bin/sh

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

# rgb/picture control
SFILE="/sys/devices/platform/kcal_ctrl.0/kcal"
CFILE="/data/data/leankernel/kcal"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE
CFILE="/data/data/leankernel/kcal_sat"
[ -f $CFILE ] && echo `cat $CFILE` > ${SFILE}_sat
CFILE="/data/data/leankernel/kcal_cont"
[ -f $CFILE ] && echo `cat $CFILE` > ${SFILE}_cont
CFILE="/data/data/leankernel/kcal_hue"
[ -f $CFILE ] && echo `cat $CFILE` > ${SFILE}_hue
CFILE="/data/data/leankernel/kcal_val"
[ -f $CFILE ] && echo `cat $CFILE` > ${SFILE}_val

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

# vibe strength
CFILE="/data/data/leankernel/pwmvalue"
SFILE="/sys/vibrator/pwmvalue"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# smb135x wakelock
CFILE="/data/data/leankernel/smb135x_use_wlock"
SFILE="/sys/module/smb135x_charger/parameters/use_wlock"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# sensor_ind wakelock
CFILE="/data/data/leankernel/sensor_ind"
SFILE="/sys/module/wakeup/parameters/enable_si_ws"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# faux sound control
CFILE="/data/data/leankernel/sc"
SFILE="/sys/module/snd_soc_wcd9320/parameters/enable_fs"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# wlan_rx wakelock
CFILE="/data/data/leankernel/wlan_rx"
SFILE="/sys/module/bcmdhd/parameters/wl_divide"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# msm_hsic wakelock
CFILE="/data/data/leankernel/msm_hsic"
SFILE="/sys/module/xhci_hcd/parameters/wl_divide"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# bcl_hotplug_enable
CFILE="/data/data/leankernel/bcl_hotplug_enable"
SFILE="/sys/module/battery_current_limit/parameters/bcl_hotplug_enable"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# power profiles
CFILE="/data/data/leankernel/pprofile"
[ -f $CFILE ] && setprop fku.perf.profile `cat $CFILE`

# cpu minfreq
CFILE="/data/data/leankernel/minfreq"
if [ -f $CFILE ]; then 
	FREQ=`cat $CFILE`
	echo $FREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
fi

# cpu maxfreq
CFILE="/data/data/leankernel/maxfreq"
if [ -f $CFILE ]; then 
	FREQ=`cat $CFILE`
	echo $FREQ > /sys/module/cpufreq/parameters/custom_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
fi
