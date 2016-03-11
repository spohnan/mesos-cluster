#!/usr/bin/env bash
#
# This will partition and
#

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

yum -y install lvm2

# Lists all block devices and skips the first two lines containing a column label and /dev/sda boot volume
DATA_VOLUMES=$(lsblk -d | awk '{ print $1 }' | grep -v "loop" | tail -n+3)

for v in $DATA_VOLUMES; do
  parted -s -- /dev/$v mklabel gpt
  parted -s -- /dev/$v mkpart primary ext4 2048s 100%
  parted -s -- /dev/$v set 1 lvm on
  sleep 2
  pvcreate /dev/${v}1
  vgcreate docker-storage /dev/${v}1
  lvcreate --wipesignatures y -n data docker-storage -l 95%VG
  lvcreate --wipesignatures y -n metadata docker-storage -l 5%VG
  break
done

echo "# Do not delete" > $SCRIPT_DIR/docker-data-volume.done

