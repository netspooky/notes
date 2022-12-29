# RE Tips: Common String Representations

_Originally posted 2022-05-09_

Strings are a good way of determining the layout of an unknown binary blob. If you can figure out how the strings are stored, you can use it as an anchor to map out other structures around them.

![image](https://user-images.githubusercontent.com/26436276/209995327-7e24d760-de7a-41c0-8ab3-28fdc5dfcb7c.png)

Image Description:

A text file explaining the common string representations.

- Length First, where the length of the string is stored before the string.
- Null Terminated, where each string ends in a null byte.
- Fixed Width, where each field is a fixed size. These can also have padding if they need to be aligned to a certain amount of bytes, AKA they must be divisible by a certain number.
