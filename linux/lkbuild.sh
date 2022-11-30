#!/bin/bash

LKBUILDVERS="20221129.1"
### LKBUILD.SH -------------------------------------------------------------------------------------
#
# This script will do the following:
# - Build the Linux kernel with specified Kconfig options (in kConf variable)
# - Build the a Debian image of this kernel
# - Boot the kernel using qemu
#
# --------------------------------------------------------------------------------------------------
# .: Host Setup :.
#
# - Assuming you are using Ubuntu or other Debian flavored distro, this will install what you need 
#   for the build system, creating debian images, and installing qemu
#   $ sudo apt update
#   $ sudo apt install make gcc flex bison libncurses-dev libelf-dev libssl-dev
#   $ sudo apt install debootstrap
#   $ sudo apt install qemu-system-x86
# - More info on how to setup using syzkaller options: https://github.com/google/syzkaller/blob/master/docs/linux/setup_ubuntu-host_qemu-vm_x86-64-kernel.md 
#
# --------------------------------------------------------------------------------------------------
# .: Script Setup :.
#
# - Create a directory called ~/kernel/ and cd into it
# - Grab create-image.sh from syzkaller, this is used to create a debian image
#   $ wget https://github.com/google/syzkaller/blob/master/tools/create-image.sh
#   - PROTIP: Change the hostname variable in this script to whatever you want. Default is "syzkaller"
# - Clone your kernel image and cd into it
#   $ git clone --branch v5.15 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
# - Copy this script to the root of your linux kernel source
# - Update the config options below
# - Run this script
#
# --------------------------------------------------------------------------------------------------
# .: Interacting with your kernel :.
#
# - The kernel will be booted using qemu. Log in with the username root and default creds.
# - The create-image script will generate keys for you
# - Put this into your ~/.ssh/config file, change the IdentityFile to wherever your kernel's debimg folder is.
# Host qemu
#   HostName localhost
#   User root
#   Port 10021
#   IdentityFile ~/kernel/linux_5.15/debimg/stretch.id_rsa
#   StrictHostKeyChecking no
# - Now you can ssh into your kernel by doing:
#   $ ssh qemu
# - You can scp files by doing
#   $ scp myfile.bin qemu:
#
# --------------------------------------------------------------------------------------------------
# .: Other Tips :.
# 
# REBUILD
#
# - If you want to rebuild your kernel, run this in the root of your Linux directory:
#   $ make clean
#
# DEBUG
#
# - This script was written to generate kernels you can debug with gdb.
# - The gdb script you need is in $KERNEL/scripts/gdb/
# - Add this to your ~/.gdbinit file, changing the path to your kernel.
# add-auto-load-safe-path /home/user/kernel/linux_5.15/scripts/gdb/vmlinux-gdb.py
# - To debug the kernel, do this:
#   $ cd /path/to/your/kernel/
#   $ gdb ./vmlinux
#   (gdb) lx-symbols
#   (gdb) target remote :1234
# - Now you are debugging the kernel!
# 
# --------------------------------------------------------------------------------------------------

### Config Options #################################################################################
KERNEL="/home/user/kernel/linux_5.15" # This is where the kernel was cloned
IMAGE="$KERNEL/debimg" # This is where the debian image will live.

# Put all the kconfig options in here
kConf=$(cat <<-END
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
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_KERNEL=y
CONFIG_GDB_SCRIPTS=y
\n
END
)

### End Config Options #############################################################################

echo "---------------------------------" >> ~/kernel/build.log
echo "[$(date)] Configuring $KERNEL" >> ~/kernel/build.log

echo -e "[$(date)] \x1b[38;5;51mConfiguring Kernel\x1b[0m"
make defconfig
make kvm_guest.config

# Add to .config
printf "$kConf" >> .config

make olddefconfig

echo "[$(date)] Start compilation" >> ~/kernel/build.log
echo -e "[$(date)] \x1b[38;5;51mCompiling the kernel\x1b[0m"

make -j`nproc`

echo "[$(date)] End compilation, starting image build" >> ~/kernel/build.log

mkdir debimg
cp ~/kernel/create-image.sh debimg/
cd debimg
echo -e "[$(date)] \x1b[38;5;51mBuilding the image\x1b[0m"
./create-image.sh

echo "[$(date)] End image build, booting image" >> ~/kernel/build.log
echo -e "[$(date)] \x1b[38;5;51mRunning the image\x1b[0m"

# This part creates a runk.sh script and runs the image in qemu for us. The script is reusable

cat << EOF >> runk.sh
#!/bin/bash

KERNEL="$KERNEL"
IMAGE="$IMAGE"

qemu-system-x86_64 \\
    -m 2G \\
    -smp 2 \\
    -kernel \$KERNEL/arch/x86/boot/bzImage \\
    -append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0 nokaslr" \\
    -drive file=\$IMAGE/stretch.img,format=raw \\
    -net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \\
    -net nic,model=e1000 \\
    -nographic \\
    -enable-kvm \\
    -cpu host \\
    -s \\
    -pidfile vm.pid \\
    2>&1 | tee vm.log
EOF

chmod +x runk.sh
./runk.sh
