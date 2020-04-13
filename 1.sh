


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

# Создаем файл подкачки
touch /mnt/var/swap/swapfile
# chattr +C должна быть применена к пустому файлу!
# Тут я перестраховываюсь, так как для подтома сжатие отключено
chattr +C /mnt/var/swap/swapfile
# С 16GB оперативной памяти нужно иметь файл подкачки минимум 4GB, 8 ‒ еще лучше (для гибернации нужно не менее 1/3 размера от RAM), а 32GB ‒ идеально
fallocate -l 4G /mnt/var/swap/swapfile
chmod 600 /mnt/var/swap/swapfile
mkswap /mnt/var/swap/swapfile
swapon /mnt/vra/swap/swapfile



genfstab -U /mnt >> /mnt/etc/fstab




arch-chroot /mnt
