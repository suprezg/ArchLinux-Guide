# ArchLinux Without dualboot

### 1.Verify UEFI boot mode
```
cat /sys/firmware/efi/fw_platform_size
```
If it returns 64 then the system is booted into x64UEFI, if it returns 32 then the system is booted into x32UEFI and if does not returns anything then it is booted into legacy/bios mode.
```
ls /sys/firmware/efi/efivars
```
### 2.Setting up the network
If you are using Ethernet this step is complete optional, it is mainly for those who are using wireless medium.
```
iwctl
device list    //this will give your device name for me it is wlan0
```
```
station wlan0 get-networks  //this will list the available network in my case it is testnet
station wlan0 connect testnet  //after this it will ask you for a password
exit
```
### 3.Setting up the disk
First list all the partitions and choose the desired partition
```
lsblk  //in my case it is /dev/sda
```
```
cfdisk /dev/sda
```
Partition Scheme:
500MB(minimum) for EFI partition & remaining for Root partition
### 4.Formating & mounting the partitions
```
lsblk
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
```
### 5.Installing basic packages
```
pacstrap -i /mnt base base-devel linux-lts linux-headers linux-firmware nano mpd mesa-utils pulseaudio intel-ucode or amd-ucode networkmanager
```
### 6.Genrate Fstab
```
genfstab -U -p /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
```
### 7.Chroot
Entering chroot environment
```
arch-chroot /mnt
```
setting the locale
```
nano /etc/locale.gen        //uncomment en_US.UTF8 UTF-8
locale-gen
```
setting up the root passoword
```
passwd
```
adding users
```
useradd -m -g users -G wheel Name
passwd Name
```
adding users to group wheel
```
EDITOR= nano visudo              //uncomment [%wheel ALL=(ALL) ALL]
```
enabling network manager
```
systemctl enable NetworkManager
```
installing grub 
```
pacman -S grub efibootmgr dosfstools os-prober mtools
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg
```
exiting chroot
```
exit
umount -lR /mnt
reboot
```

### 8.After reboot
setting up the timezone
```
timedatectl list-timezones
timedatectl set-timezone ur_time_zone
systemctl enable systemd-timesyncd
```
setting up the hostname
```
hostnamectl set-hostname ur_hostname
cat /etc/hostname
```
adding your host to hosts file
```
nano /etc/hosts
```
```
127.0.0.1      localhost
::1            localhost
127.0.1.1      ur_hostname
```
```
hostnamectl
```
# Utilities








