#!/bin/sh
# helper script to resume suspended VM's

VAR_PREV_TIMEDATE=$(cat /tmp/foo.txt)
VAR_TIMEDATE=$(date +%Y%m%d%H%M%S)
while read -r LINE; do

  VAR_STATE=$(vim-cmd vmsvc/power.getstate $LINE | xargs | sed 's/Retrieved runtime info //')
  if [ "$VAR_STATE" == 'Suspended' ]; then
    vim-cmd vmsvc/power.on $LINE > /tmp/trash_$VAR_TIMEDATE.txt
  fi

done < /tmp/susp_vms_$VAR_PREV_TIMEDATE.txt

rm /tmp/susp_vms_$VAR_PREV_TIMEDATE.txt /tmp/trash_$VAR_TIMEDATE.txt /tmp/foo.txt
