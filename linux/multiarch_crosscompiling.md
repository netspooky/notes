Notes relevant to mutliarch and cross compiling 

# Setting up 32bit ARM on aarch64

Lets say you see something like this
```
pi@rpi4:~/ $ ./myBin
./myBin: error while loading shared libraries: myLib.so: wrong ELF class: ELFCLASS64
```
If you want to install armhf on an aarch64 system (eg raspbian on raspberry pi 4), do this:
```
sudo dpkg --add-architecture armhf
sudo apt install libc6:armhf
```
This adds the option to use this arch via dpkg. Then installing the armhf version of libc6 will allow you to use libraries as the linker for libc is now available (as well as the standard library)
