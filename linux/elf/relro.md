# ELF RELRO
From 2022-09-21

### Question
How do you verify if a binary is compiled with RELRO? What do all the flags mean?

### Answer

The docs and online discussions about this are super confusing. The whole point of doing RELRO is to set RTLD_NOW when the linker calls [dlopen](https://man7.org/linux/man-pages/man3/dlopen.3.html) in some way. This tells the linker to resolve everything before execution (this actually happens before dlopen returns) and map the area the GOT is in as read-only.

This can be done in a few ways:
- DT_BIND_NOW - A .dynamic section tag that explicitly sets this flag.
- DF_BIND_NOW - A flag within the DT_FLAGS tag in the .dynamic section.
- DF_1_NOW - A flag within DT_FLAGS_1, another .dynamic tag.
- LD_BIND_NOW - This environment variable being a non-empty string will also trigger this.

Since these are linker instructions, there's nothing stopping a linker from either not supporting something, or ignoring the tag all together.

The best way to verify is to run the binary on the target system and check the memory permissions for the area that the GOT is in. If it's marked read only, then it was a success.

Trusting tools like readelf or checksec can lead to a false sense of security, as they can be easily manipulated via malicious crafted ELFs, or with linker/compiler/runtime bugs that can lead to weird outcomes.
