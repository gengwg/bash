#!/bin/bash

# Automatically Resolve NFS Stale File Handle Errors
# 
# Usage:
# Create a cronjob: 
#   */5 * * * * /path/to/stale_handle_destroyer.sh

# Explain of the quotes for the search for stale file handlers line
# On Centos 7, df 8.22, the output has special quote characters returned from df, like this "‘". 
# Need remove them on those versions of hosts/df.
# 
# $df -h
# df: ‘/mnt/sharptest’: Stale file handle # <-------
# Filesystem                                                       Size  Used Avail Use% Mounted on
# devtmpfs                                                         378G     0  378G   0% /dev
# tmpfs                                                            378G     0  378G   0% /dev/shm
# 
# Centos 8 has no such quotes.
# df -h
# df: /mnt/sharptest: Stale file handle # <-------------
# Filesystem                                                       Size  Used Avail Use% Mounted on
# devtmpfs                                                         252G     0  252G   0% /dev
# tmpfs                                                            252G  440K  252G   1% /dev/shm

# search for stale file handlers
list=$(df 2>&1 | grep 'Stale file handle' | awk '{print ""$2"" }' |  tr -d : |  tr -d "‘" | tr -d "’")
for directory in $list
do
  # using lazy unmount is safest
	umount -l "$directory"
  # then attempt to remount
	mount -a
done
