# Create bootable USB

[How to Create a Bootable Ubuntu USB Drive, for Mac, in OS X](https://business.tutsplus.com/tutorials/how-to-create-a-bootable-ubuntu-usb-drive-for-mac-in-os-x--cms-21253)

* $ `hdiutil convert -format UDRW -o ~/path/to/target.img ~/path/to/ubuntu.iso`
* $ `diskutil unmountDisk /dev/disk2`
* $ `sudo dd if=/path/to/ubuntu-14.04-desktop-amd64+mac.img.dmg of=/dev/disk2 bs=1m`
* $ `diskutil eject /dev/disk2`