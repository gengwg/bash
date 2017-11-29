#!/usr/bin/env sh
# Usage:
# pskill.sh prog

if [ -z $1 ]; then
    echo "Must provide program name to kill."
    exit 1
else
    PROG=$1
fi

GREP=[${PROG:0:1}]${PROG:1:${#PROG}}
PIDS=$(ps aux | grep $GREP | awk '{print $2}')
if [ -z $PIDS ]; then
    echo "No program named $PROG exists."
    exit 2
else
    echo "Killing all $PROG"
    kill $PIDS
fi
