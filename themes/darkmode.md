Here are various ways of doing darkmode on different things.

Dark Mode in Windows 10, use regedit to change this key. Works without needing to activate Windows.
```
HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize\\AppsUseLightTheme = 0
```

Bootleg QT dark mode on Wireshark >= 3.4.4 on Windows. 
```
"C:\\Program Files\\Wireshark\\Wireshark.exe" -platform windows:darkmode=2
```

Ghidra Dark mode! [https://github.com/zackelia/ghidra-dark](https://github.com/zackelia/ghidra-dark) 
- TIP: Just download flatlaf JAR file from line 40 in install.py and put it in the Ghidra install folder (wherever ghidraRun is). 
- I installed like `python3 install.py -p "C:\Users\user\Documents\Tools\ghidra_10.0.4_PUBLIC_20210928\ghidra_10.0.4_PUBLIC"`
