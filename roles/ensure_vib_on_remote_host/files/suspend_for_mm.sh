#!/bin/sh
# helper script to suspend VM's for maintenance mode

VAR_TIMEDATE=$(date +%Y%m%d%H%M%S)
vim-cmd vmsvc/getallvms | tail -n+2 | awk -F" " '{ print $1 }' > /tmp/vms_$VAR_TIMEDATE.txt
while read -r LINE; do

  VAR_STATE=$(vim-cmd vmsvc/power.getstate $LINE | xargs | sed 's/Retrieved runtime info //')
  if [ "$VAR_STATE" == 'Powered on' ]; then
    echo $LINE >> /tmp/susp_vms_$VAR_TIMEDATE.txt
    vim-cmd vmsvc/power.suspend $LINE > /tmp/trash_$VAR_TIMEDATE.txt
  fi

done < /tmp/vms_$VAR_TIMEDATE.txt

rm /tmp/vms_$VAR_TIMEDATE.txt /tmp/trash_$VAR_TIMEDATE.txt
echo $VAR_TIMEDATE > /tmp/foo.txt
