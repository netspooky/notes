These are my notes on setting up and running syzkaller. For a full guide check out the docs. https://github.com/google/syzkaller/blob/master/docs/linux/setup.md

Use all these at your own risk!

# Kernel config

General good kconfig options for syzkaller.

```
# Coverage collection.
CONFIG_KCOV=y

# Debug info for symbolization.
CONFIG_DEBUG_INFO=y

# Memory bug detector
CONFIG_KASAN=y
CONFIG_KASAN_INLINE=y

# Required for Debian Stretch
CONFIG_CONFIGFS_FS=y
CONFIG_SECURITYFS=y
```
Additional syzkaller related ones are here: https://github.com/google/syzkaller/blob/master/docs/linux/kernel_configs.md

Other useful ones
```
CONFIG_USER_NS=y
CONFIG_SLAB_DEBUG=y
```

PROTIP: To learn about any standard CONFIG option, use this website. Remove the `CONFIG_` part of the variable to search.
- eg. `CONFIG_KASAN` info: https://cateee.net/lkddb/web-lkddb/KASAN.html

# Quick Compile

Clone the branch you want. Check the releases section for tag names.
```
git clone --branch v5.17-rc5 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
cd linux
```
Now generate the configs
```
make defconfig
make kvm_guest.config
```
Add to the .config file
```
CONFIG_CONFIGFS_FS=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_KASAN=y
CONFIG_KASAN_INLINE=y
CONFIG_KCOV=y
CONFIG_KCOV_ENABLE_COMPARISONS=y
CONFIG_KCOV_INSTRUMENT_ALL=y
CONFIG_SECURITYFS=y
CONFIG_SLAB_DEBUG=y
CONFIG_USER_NS=y
```
Now load up all these into your config
```
make olddefconfig
```
Finally, make the kernel image
```
make -j`nproc`
```
Now you have to create a debian image. You can use https://github.com/google/syzkaller/blob/master/tools/create-image.sh to make one with a stock config.
```
mkdir debimg
cp ~/kernel/create-image.sh debimg/
cd debimg
./create-image.sh
```

# Running your image
Definitely follow the guide for more info, but generally you want to set up a few things in your config. Namely the workdir, the kernel objects, and the keys.

```
{
  "name": "Hello",
  "target": "linux/amd64",
  "http": "0.0.0.0:56741",
  "workdir": "/home/user/syzkaller/workdir",
  "kernel_obj": "/home/user/kernel/linux/",
  "image": "/home/user/kernel/5.17-rc5/linux/debimage/stretch.img",
  "sshkey": "/home/user/kernel/5.17-rc5/linux/debimage/stretch.id_rsa",
  "syzkaller": "/home/user/syzkaller",
  "procs": 8,
  "type": "qemu",
  "reproduce": true,
  "suppressions": [
    "no output from test machine"
  ],
  "vm": {
    "count": 4,
    "kernel": "/home/user/kernel/5.17-rc5/linux/arch/x86/boot/bzImage",
    "cpu": 2,
    "mem": 2048
  }
}
```
Finally you can run with qemu
```
qemu-system-x86_64 \
	-m 2G \
	-smp 2 \
	-kernel /home/user/kernel/5.17-rc5/linux/arch/x86/boot/bzImage \
	-append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0" \
	-drive file=/home/user/kernel/5.17-rc5/linux/debimage/stretch.img,format=raw \
	-net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
	-net nic,model=e1000 \
	-enable-kvm \
	-nographic \
	-pidfile vm.pid \
	2>&1 | tee vm.log
```
Now you can connect to the running kernel with
```
ssh -i ~/kernel/5.17-rc5/linux/debimg/stretch.id_rsa -p 10021 root@127.0.0.1
```
Transfer files:
```
scp -i ~/kernel/5.17-rc5/linux/debimg/stretch.id_rsa -P 10021 stupid_bug.c root@127.0.0.1:
```
If you're doing a lot of testing, you might need to clear your ssh keys from known_hosts if you can't connect.
```
ssh-keygen -f "/home/user/.ssh/known_hosts" -R "[127.0.0.1]:10021"
```

