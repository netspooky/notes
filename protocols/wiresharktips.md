# Wireshark Tips

[https://gitlab.com/wireshark/wireshark/-/wikis/home](https://gitlab.com/wireshark/wireshark/-/wikis/home) The wireshark wiki

Additional oneliners here: https://github.com/netspooky/notes/blob/main/linux/oneliners.md#tshark-and-wireshark

## Install wireshark from source
This is how you do it on Linux at least
```
git clone https://gitlab.com/wireshark/wireshark.git
cd wireshark
sudo ./tools/debian-setup.sh
mkdir build
cd build
cmake ..
make
```
Now you can run with:
```
run/wireshark
```

## Dissector stuff

[https://mika-s.github.io/wireshark/lua/dissector/2017/11/04/creating-a-wireshark-dissector-in-lua-1.html](https://mika-s.github.io/wireshark/lua/dissector/2017/11/04/creating-a-wireshark-dissector-in-lua-1.html)

[https://www.wireshark.org/docs/wsdg_html_chunked/wslua_tap_example.html](https://www.wireshark.org/docs/wsdg_html_chunked/wslua_tap_example.html)

This is really useful for reference

[11.6. Functions For New Protocols And Dissectors](https://www.wireshark.org/docs/wsdg_html_chunked/lua_module_Proto.html)

### Calling another dissector

[https://www.wireshark.org/docs/wsdg_html_chunked/lua_module_Proto.html](https://www.wireshark.org/docs/wsdg_html_chunked/lua_module_Proto.html)

The `buf(offset):tvb()` arg is important. offset is where in the previous buffer to start, and :tvb() casts it from userdata to a tvb

```lua
function proto_lap5.dissector(buf, pinfo, tree)
    if buf:len() > HEADER_LEN then
        -- create a new buffer containing only the XLES data,
        -- and pass it to the XLES dissector
        Dissector.get("xles"):call(buf(HEADER_LEN):tvb(), pinfo, tree)
    end
end
```

### Dealing with UTF16 strings

this is actually a really sick way to do this...it goes by the null terminated string...

```lua
msg_f = ProtoField.string("mydissector.msg", "msg")
local getMsg = buffer(13) -- starting on byte 13
local msg = getMsg:le_ustring()
subtree:add(msg_f,  getMsg, msg)
```

# Capturing Bluetooth
Tested on Ubuntu 22.04
- Enable Bluetooth in settings
- Use the bluetooth-monitor interface
- Use this filter to get advertising reports `bthci_evt.le_meta_subevent == 0x02`
- Filter for one device `btcommon.eir_ad.entry.device_name == "My Device"`
- Filter on MAC addrs `bthci_evt.bd_addr == 55:55:55:55:55:55`
- See messages with manufacturer data `btcommon.eir_ad.entry.data`
