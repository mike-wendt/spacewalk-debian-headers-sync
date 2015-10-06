#!/bin/bash
# Strips out all binary file data from package to in effect only load the headers into Spacewalk

# Grab name of binary file to replace
FILE=`ar t ${1} | sort | tr '\n' ' ' | awk '{ print $2 }'`

# Replaces the binary content with a zero byte file
cd /tmp
touch $FILE
ar ro ${1} $FILE

# Sleep to prevent deadlocking from multiple rhnpush commands at once
sleep 1
