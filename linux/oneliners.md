There's so many one liners I forget, so I will put them here.

### Misc Useful
Find duplicate files
```
find . ! -empty -type f -exec md5sum {} + | sort | uniq -w32 -dD
```
Extract all zip files in current directory
```
find . -name "*.zip" -exec mkdir {}_ \; -exec mv {} {}_/ \; -exec 7z x {}_/{} -o{}_/ \;
```
generate uuid
```
cat /proc/sys/kernel/random/uuid
```
How to use USBPCAP on Ubuntu
```
sudo modprobe usbmon
sudo setfacl -m u:$USER:r /dev/usbmon*
```
Disable system beep
```
rmmod pcspkr ; echo "blacklist pcspkr" >>/etc/modprobe.d/blacklist.conf
```

### Vim, Regex, Grep

remove trailing whitespace regex
```
[^\S\r\n]+$
```
How to remove all lines containing value REMOVEME
```
^.*REMOVEME.*\n
```
Vim: Remove all blank lines in a file
```
:g/^$/d
```
Find all memcpy instances in a dir (with line numbers)
```
grep --color -rin memcpy .
```

### Hex Stuff
Here's a tutorial I made about using Vim as a hex editor: https://twitter.com/netspooky/status/1553047692678414337

copy intel hex format to bin
```
objcopy -I ihex file.hex -O binary file.bin
```
reverse hex dump
```
cat asciihex.txt | xxd -r -p > file.bin
```
base64 to bin
```
base64 -d <<< someb64here > file.bin
```
perl hexdump
```
perl -e 'local $/; print unpack "H*", <>' file.bin
```
convert hex value to decimal
```
printf "%d\n" $((16#6132387a))
```

### Tshark and Wireshark

Convert a packet to binary from the command line
```
tshark -x -r file.pcap -Y “frame.number==[packet#]” | xxd -r > file.bin
```
tshark find byte patterns
```
tshark -r some.pcap -Y 'data.data contains "\x12\x34"' -T fields -e data
```
wireshark get first 500 frames
```
frame.number < 501
```
wireshark get frames 450-500
```
frame.number < 501 and frame.number > 450
```
tshark just grab some fields (in this case grabbing `bgblink.sync1_dv` with a filter (here it's `"bgblink.command == 104 and ip.src == 127.0.0.1"`)
```
tshark -r gameboy.pcapng -Y "bgblink.command == 104 and ip.src == 127.0.0.1" -T fields -e bgblink.sync1_dv
```
tshark list all protocols in a given pcap
```
tshark -r nasdaq.pcap -T fields -e frame.protocols | sort -u
```
