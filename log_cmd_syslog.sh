#!/bin/bash

alias ssh='ssh -q'
log_cmd () {
  # log command ran to syslog with tag 'myapp'
  echo $1 | logger -t 'myapp'
  # redirect command output to dev null
  $1 >> /dev/null
  #$1
}

log_cmd 'echo abcd'
log_cmd 'ssh wenxia uptime'
echo "DONE"
