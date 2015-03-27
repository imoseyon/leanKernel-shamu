#!/system/bin/sh

# selinux mode
CFILE="/data/data/leankernel/selinux_permissive"
SFILE="/sys/fs/selinux/enforce"
[ -f $CFILE ] && echo 0 > $SFILE

# freq mitigation mitigator - needs to run earlier than lk-post-boot.sh
CFILE="/data/data/leankernel/allow_maxdown"
SFILE="/sys/module/msm_thermal/parameters/full_fm"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE
