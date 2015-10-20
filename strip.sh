#!/bin/bash
# Strips out all binary file data from package to in effect only load the headers into Spacewalk

# Grab arguments
channel=$2
username=$3
password=$4

# Grab name of binary file to replace
FILE=`ar t ${1} | sort | tr '\n' ' ' | awk '{ print $2 }'`

# Replaces the binary content with a zero byte file
cd /tmp
if [ ! -f /tmp/$FILE ]; then
  touch $FILE
fi
ar ro ${1} $FILE

# Push file to Spacewalk
rhnpush -c $channel -u $username -p $password ${1} &> /dev/null

# Check if file was uploaded; if not try once more
if [ $? -ne 0 ]; then
  echo "ERROR: Upload failed - waiting and retrying : ${1}"
  sleep $[ ( $RANDOM % 30 ) + 10 ]
  rhnpush -c $channel -u $username -p $password ${1} &> /dev/null

  # See if second time was a success
  if [ $? -ne 0 ]; then
    echo "ERROR: Aborting upload - second failure to upload : ${1}"
  fi
fi

# Remove file
rm ${1}
