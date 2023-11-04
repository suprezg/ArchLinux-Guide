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

### 1.Installing i3
```
sudo pacman -Syu xorg xorg-xinit i3-wm lightdm lightdm-gtk-greeter firefox dolphin htop git
sudo systemctl enable lightdm
```
for shortcuts on i3 visit [i3](https://i3wm.org/docs/refcard.html).      
the basic configuration file is present on this repo.
### 2.Alacritty
```
sudo pacman -Syu alacritty
```
the basic configuration file is present on this repo.    
some alacritty themes are present in this repo [1](https://github.com/eendroroy/alacritty-theme).
### 3.Installing new fonts
we will be using nerd fonts visit [nerd fonts](https://www.nerdfonts.com/font-downloads).We will be installing our font zip file in downloads directory.
```
cd /usr/share
mkdir fonts
cd fonts
mkdir ur-fontname
cd ur-fontname
cp ~/Downloads/ur-fontname.zip /usr/share/fonts/ur-fontname
unzip ur-fontname.zip
```
Using this command you can retrieve your font name
```
fc-cache -vf
fc-match ur-fontname -a
```
### 4.ACPI
It is used to check the battery level
```
sudo pacman -Syu acpi
acpi -b
```
### 5.Neovim
```
sudo pacman -Syu neovim
```
using nvchad
```
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
```
```
ctrl+t+h       //opens themes pallete
ctrl+c+h       //opens cheatsheet
:Tsinstall ur-language      //installs syntax highlighting for ur-language
```
### 6.Rofi
```
sudo pacman -Syu rofi
mkdir .config/rofi
nvim rofi.rasi
```
there are various themes available for rofi [1](https://github.com/joni84/rofi).You can put a keybind for int in your config directory.
### 7.Flameshot
It is used for screen shot, you can access it through rofi.
```
sudo pacman -Syu flameshot
flameshot gui
```
You can also use it by putting a keybind in your config directory.
### 8.sxiv
simple x image viewr
```
sudo pacman -Syu sxiv
sxiv image-name.extension
```
### 9.feh
it is used to set the wallpaper
```
sudo pacman -Syu feh
feh --bg-fill ur-wallpaperlocation
```
you can also put it in your config directory so it enables at startup
### 10.NetworkManager
```
nmcli device wifi list
nmcli device wifi connect SSID_or_BSSID password ur-password
```







