# SPDX-License-Identifier: GPL-2.0

obj-y				:= core.o
obj-$(CONFIG_DAMON_VADDR)	+= ops-common.o vaddr.o
obj-$(CONFIG_DAMON_PADDR)	+= ops-common.o paddr.o pte_scan.o
obj-$(CONFIG_DAMON_SYSFS)	+= sysfs-common.o sysfs-schemes.o sysfs.o
obj-$(CONFIG_DAMON_DBGFS)	+= dbgfs.o
obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o

obj-m	+= core.o offload.o
offload-y := modules-common.o smart_offload.o

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

ccflags-y += -DDEBUG -g

default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules
