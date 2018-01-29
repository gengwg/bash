#!/usr/bin/env bash
########################################################
###
### Successful and failed login attempts of a particular
### user.
###
#######################################################
if [[ $# < 1 ]]; then
    echo "Usage: $0 <user>"
    echo "For example: $0 gengwg"
    echo ""
    exit
fi

echo "Successful login attempts: "
echo "-----"
last | grep $1
echo "Failed login attempts: "
echo "-----"
lastb | grep $1

