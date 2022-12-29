# Vim Hex Editor Tutorial

_Originally Posted 2022-07-29_

Open file, type `:%!xxd` to enter hex mode

![Vim with "This is some text", typing the command :%!xxd](https://user-images.githubusercontent.com/26436276/209995509-af56ec0e-5924-42c7-9bac-96da91ee0d27.png)

Optional - Turn on hex syntax highlighting with `:set ft=xxd`

![vim in hex editor mode, syntax highlighting done with :set ft=xxd](https://user-images.githubusercontent.com/26436276/209995529-2300f14a-d348-4678-8173-dc0fab77fce1.png)

Make changes to the hex bytes

![Making changes to the hex dump in vim](https://user-images.githubusercontent.com/26436276/209995559-ba2505a1-cd76-439b-86bb-88f1332a035b.png)

Leave hex mode with `:%!xxd -r`

![Switching out of hex mode with :%!xxd -r](https://user-images.githubusercontent.com/26436276/209995593-eb863ae7-f01b-4898-a18c-da306bca9a35.png)

Exit vim with `:call libcallnr("libc.so.6","exit",0)`
