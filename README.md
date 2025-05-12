# Hot-Page Detection Offloading to Smart Device

## Building the Linux Kernel 6.11.9-smart-offload

```bash
$ cp config-smart-offload kernel/.config
$ cd kernel
$ make -j$(nproc)
$ make modules -j$(nproc)
$ sudo make modules_install -j$(nproc)
$ sudo make install -j$(nproc)
```


## Boot into the Linux Kernel 6.11.9-smart-offload

1. Modify `/etc/default/grub`:
```bash
GRUB_CMDLINE_LINUX_DEFAULT="intel_pstate=disable"
```
2. Update `grub.cfg` and reboot into the kernel:
```bash
$ sudo update-grub
```

3. Disable swap
```bash
$ sudo swapoff -a
```
