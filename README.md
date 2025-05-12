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

## Enable Smart Offload Kernel Module

1. Build kernel module:
```bash
$ cd kernel/mm/damon
$ make
```
2. Insert kernel module:
```bash
$ sudo insmod offload.ko
```

3. Pin offloading kernel thread to NUMA node `node_id`
```bash
$ sudo sh -c 'echo `node_id` > /sys/module/offload/parameters/damon_smart_offload.numa_node'
```

4. Enable smart offloading kernel thread
```bash
$ sudo sh -c 'echo Y > /sys/module/offload/parameters/damon_smart_offload.enabled'
```

5. Disble smart offloading kernel thread
```bash
$ sudo sh -c 'echo N > /sys/module/offload/parameters/damon_smart_offload.enabled'
```

## Microbenchmark

### Baseline
```bash
$ cd benchmark
$ ./baseline.sh
$ python3 avg_cycles.py
```

### Proposal
```bash
$ cd benchmark
$ ./proposal.sh
$ python3 avg_cycles.py
```


## Adjusting Kernel Module Parameters

### Sampling Intervals
```bash
$ sudo sh -c 'echo `interval` > /sys/module/offload/parameters/damon_smart_offload.sample_interval'
$ sudo cat /sys/module/offload/parameters/damon_smart_offload.sample_interval
```

### Min-Max Regions
```bash
$ sudo sh -c 'echo `min` > /sys/module/offload/parameters/damon_smart_offload.min_nr_regions'
$ sudo sh -c 'echo `max` > /sys/module/offload/parameters/damon_smart_offload.max_nr_regions'
$ sudo cat /sys/module/offload/parameters/damon_smart_offload.min_nr_regions
$ sudo cat /sys/module/offload/parameters/damon_smart_offload.max_nr_regions
```

