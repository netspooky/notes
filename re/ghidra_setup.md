# Linux Ghidra Setup
Updated 2023-02-01

This worked on Ubuntu 22.04 with Ghidra 10.2.2

```
sudo apt update
sudo apt install openjdk-17-jdk
sudo apt install openjdk-17-jre
java -version # Confirm it's installed
# Download latest from https://github.com/NationalSecurityAgency/ghidra/releases
wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.2.2_build/ghidra_10.2.2_PUBLIC_20221115.zip
7z x ghidra_10.2.2_PUBLIC_20221115.zip
cd ghidra_10.2.2_PUBLIC_20221115/
./ghidraRun
```
