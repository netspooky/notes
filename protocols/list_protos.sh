#!/bin/bash
# List all the protocols detected in every pcap in a directory
c1="\033[38;5;228m"
c2="\033[38;5;122m"
for file in $1/*
do
 if [ "$file" != $0 ] ; then
  echo -e "$c1$file$c2"
  tshark -r "$file" -T fields -e frame.protocols | sort -u
  echo -e "\033[0m"
 fi
done
