#!/bin/bash -xe

yum install -y nvme-cli

SSD_NVME_DEVICE_LIST=($(nvme list | grep "Amazon EC2 NVMe Instance Storage" | cut -d " " -f 1 || true))

if [ -z "${SSD_NVME_DEVICE_LIST}"]; then
  echo "No local SSDs."
else
  SSD_NVME_DEVICE_COUNT=${#SSD_NVME_DEVICE_LIST[@]}
  RAID_DEVICE=${RAID_DEVICE:-/dev/md0}
  RAID_CHUNK_SIZE=${RAID_CHUNK_SIZE:-512}  # Kilo Bytes
  FILESYSTEM_BLOCK_SIZE=${FILESYSTEM_BLOCK_SIZE:-4096}  # Bytes
  STRIDE=$(expr $RAID_CHUNK_SIZE \* 1024 / $FILESYSTEM_BLOCK_SIZE || true)
  STRIPE_WIDTH=$(expr $SSD_NVME_DEVICE_COUNT \* $STRIDE || true)

  # Perform provisioning based on nvme device count
  case $SSD_NVME_DEVICE_COUNT in
  "0")
    echo 'No devices found of type "Amazon EC2 NVMe Instance Storage"'
    echo "Maybe your node selectors are not set correctly"
    exit 1
    ;;
  "1")
    mkfs.ext4 -m 0 -b $FILESYSTEM_BLOCK_SIZE $SSD_NVME_DEVICE_LIST
    DEVICE=$SSD_NVME_DEVICE_LIST
    ;;
  *)
    mdadm --create --verbose $RAID_DEVICE --level=0 -c ${RAID_CHUNK_SIZE} \
      --raid-devices=${#SSD_NVME_DEVICE_LIST[@]} ${SSD_NVME_DEVICE_LIST[*]}
    while [ -n "$(mdadm --detail $RAID_DEVICE | grep -ioE 'State :.*resyncing')" ]; do
      echo "Raid is resyncing.."
      sleep 1
    done
    echo "Raid0 device $RAID_DEVICE has been created with disks ${SSD_NVME_DEVICE_LIST[*]}"
    mkfs.ext4 -m 0 -b $FILESYSTEM_BLOCK_SIZE -E stride=$STRIDE,stripe-width=$STRIPE_WIDTH $RAID_DEVICE
    DEVICE=$RAID_DEVICE
    ;;
  esac

  UUID=$(blkid -s UUID -o value $DEVICE)
  mkdir -p /local-ssd
  mount -o defaults,noatime,discard,nobarrier --uuid $UUID /local-ssd
  echo "Device $DEVICE has been mounted to /local-ssd"
  echo "NVMe SSD provisioning is done"
fi
