


mkfs.fat -F32 -n ESP /dev/nvme0n1p1
mkfs.btrfs -f /dev/nvme0n1p2

mkdir -p /mnt

mount /dev/nvme0n1p2 /mnt

# Потом создаем на нем подтома
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@swap

# Теперь мы демонтируем устройство
umount /mnt

mkdir -p /mnt/boot/efi /mnt/var/swap /mnt/home


mount -o rw,noatime,compress=zstd:3,ssd,space_cache,subvol=@ /dev/nvme0n1p2 /mnt
mount /dev/nvme0n1p1 /mnt/boot/efi
mount -o noatime,compress=zstd:3,space_cache,subvol=@home /dev/nvme0n1p2 /mnt/home
mount -o rw,noatime,compress=no,ssd,space_cache,subvol=@swap /dev/nvme0n1p2 /mnt/var/swap
