mount -o rw,noatime,compress=zstd:3,ssd,space_cache,subvol=@ /dev/nvme0n1p5 /mnt
mount /dev/nvme0n1p2 /mnt/boot/efi
mount -o noatime,compress=zstd:3,space_cache,subvol=@home /dev/nvme0n1p5 /mnt/home
mount -o rw,noatime,compress=no,ssd,space_cache,subvol=@swap /dev/nvme0n1p5 /mnt/var/swap
