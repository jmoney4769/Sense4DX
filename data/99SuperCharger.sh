#!/system/bin/sh
# V6 SuperCharger, OOM Grouping & Priority Fixes created by zeppelinrox.
execute=0;
currentadj=`cat /sys/module/lowmemorykiller/parameters/adj`;
currentminfree=`cat /sys/module/lowmemorykiller/parameters/minfree`;
scadj=`cat /data/SuperChargerAdj`;
scminfree=`cat /data/SuperChargerMinfree`;
if [ "$currentadj" != "$scadj" ]; then
	execute=1;
elif [[ -n "$scminfree" ]] && [ "$currentminfree" != "$scminfree" ]; then
	execute=1;
fi;
if [ "$execute" -eq 1 ]; then
	mount -o remount,rw /system 2>/dev/null;
	for m in /dev/block/mtdblock*;
	do
	mount -o remount,rw $m /system 2>/dev/null;
	done;
	echo $scadj > /sys/module/lowmemorykiller/parameters/adj;
	echo $scminfree > /sys/module/lowmemorykiller/parameters/minfree;
	busybox sysctl -w vm.oom_kill_allocating_task=0;
	busybox sysctl -w vm.panic_on_oom=0;
	busybox sysctl -w kernel.panic_on_oops=1;
	busybox sysctl -w kernel.panic=0;
	mount -o remount,ro /system 2>/dev/null;
	for m in /dev/block/mtdblock*;
	do
	mount -o remount,ro $m /system 2>/dev/null;
	done;
fi;
# End of V6 SuperCharged Entries
