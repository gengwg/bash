#!/usr/bin/env bash
# Usage:
# pskill.sh prog

if [ -z "$1" ]; then
    echo "Must provide program name to kill."
    exit 1
else
    PROG=$1
fi

mapfile -t PIDS < <(pgrep -x -- "$PROG")
if [ "${#PIDS[@]}" -eq 0 ]; then
    echo "No program named $PROG exists."
    exit 2
else
    echo "Killing all $PROG"
    kill "${PIDS[@]}"
fi
