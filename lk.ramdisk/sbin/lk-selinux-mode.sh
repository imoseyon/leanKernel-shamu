#!/system/bin/sh

CFILE="/data/data/leankernel/selinux_permissive"
SFILE="/sys/fs/selinux/enforce"
[ -f $CFILE ] && echo 0 > $SFILE
