# RE Tips: Timestamps

_Originally Posted: 2021-09-10_

If you're analyzing an unknown protocol or binary format, know your time stamps!

Let's say you know the pcap (or file) was created in the last 24 hours.

Right now it's 1631293496 in Unix time.
- In hex: 613B9038
- In ASCII: "a;\x908"

https://unixtimestamp.com

If we go back exactly 24 hrs, the time is 1631221496.
- In hex: 613A76F8
- In ASCII: "a:v\xF8"

Now you can look in the hex dump for "a" and either ":" or ";" beside it. If you don't know the endianness, this can be a good way to figure that out. Can also align fields around it.

Not all protocols or file formats will have timestamps included, but it's common enough that it's a good thing to search for, especially if there are few strings.

There are lots of other timestamp formats that are helpful to know. Familiarize yourself for gr8 victory.

Example: Given this, if found a timestamp, you can probably assume that there's _some_ of boundary at 0xC1. It's lil endian, and now you can trace other values.

- Is 0xA5 a virtual address? 
- Is 0xB9 a boolean?
- Is 0xCB a bit pattern?

These are the questions you wanna ask.

![highlighted hex dump that is described by the writeup](https://user-images.githubusercontent.com/26436276/209995891-483dc310-bce2-41fa-b7dc-893b4a31149e.png)
