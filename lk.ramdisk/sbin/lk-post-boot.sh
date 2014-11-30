#!/system/bin/sh

# for lkconfig
[ ! -d "/data/data/leankernel" ] && mkdir /data/data/leankernel
chmod 755 /data/data/leankernel

# init.d support
/system/xbin/busybox run-parts /system/etc/init.d

echo N > /sys/module/cpu_boost/parameters/cpuboost_enable
