#!/usr/bin/env bash
# 
# Example of a Bash main program calling different functions based on given argument
#
### Setup a local dev environment
#
### Pre-Flight Check ###
#
# These instructions are intended specifically for running on MacOS 10.
# Although small modifications should make it run on Linux.
#
# * You MUST have access to VPN and connected.
# * You MUST have Vagrant and VirtualBox installed, and work properly.
# * You MUST have Python installed. We tested 2.7.10.
# * If you want to test functional test locally (e.g. venv), you need install all the PIPs
#   in requirements.txt.
# * (Optional) A beer at hand while code running.
#
### USAGE
# 
# * there is a git repo containing all source files and appropriate configuration
# * there is a README file containing instructions for how to setup the dev environment
# * set up dependencies (install local software, RPMs, Python eggs, etc) from a script
# * run / debug application using an IDE (ideally PyCharm)
# * there's a "hello world" page 
# * unit test that does something useful
# * functional test that does something useful
# * can trigger running unit tests, functional tests, or both
#
# Run: ./app up
# 
# Usage: ./app <subcommand>
#     subcommands:
#         help            --> show this message
#         up              --> start up a new dev env
#         destroy         --> destroy current dev env
#         hello_world     --> hello world
#         status          --> status
#         test            --> unit tests
 

ME=`basename $0`
VERSION='0.1.0'
VERBOSE=false
args=("$@")
arglen=$#

set -e

if $VERBOSE
then
  set -x
fi

usage()
{
    usage="$(basename "$0") -- program to calculate the answer to life
Usage: $0 <subcommand>
    subcommands:
        help            --> show this message
        up              --> start up a new dev env
        destroy         --> destroy current dev env
        hello_world     --> hello world
        status          --> status
        pull_api        --> pull lates api code
        pull_mysqldb    --> pull lates mysql db
        ut              --> unit tests
        ft              --> functional tests
        ui              --> show swagger api page 
    "
    echo "$usage"
    exit 1
}

pull_api()
{
    # pull latest flask code
    echo '--> Pulling latest App API source code'

    repourl='git@github.com:gengwg/app-api.git'

    if [ -d ./app-api ]; then
        cd ./app-api && git pull
        cd ..
    else
        git clone $repourl
    fi

}

pull_mysqldb()
{   # pull latest mysql db
    echo '--> Pulling latest mysql DB'
    python pull_mysqldb.py
}

ui ()
{
    echo '--> Opening browser and redirect to http://localhost:60510/v1/ui/'
    open http://localhost:60510/v1/ui/
}

ut ()
{ # Run unit tests.
    echo '--> Running unit tests...'
    vagrant ssh -c 'cd /vagrant/app-api && python -m unittest discover'
    #cd app-api && python -m unittest discover
}

ft ()
{ # Run functional tests.
    echo '--> Running functional tests...'
    python functional_test.py
}

main ()
{
    echo '--> Hello, please wait while I set up dev environment for you'

    pull_api

    pull_mysqldb

    echo '--> Starting dev environment'
    vagrant up
    #vagrant destroy -f && vagrant up

    sleep 3 
    ui

    echo '--> Congratulations! You are all set!'
    echo '--> Now try a app cli: "app hello_world".'
    echo '--> For more information: "app help".'
}

destroy ()
{ # destroy the dev vm
    vagrant destroy -f
}

status ()
{ # status
    echo '--> vm status:'
    vagrant status | grep virtualbox

    echo '--> app api status:'
    (vagrant ssh -c 'ps aux | grep run.py | grep -v vagrant' &> /dev/null) && echo 'app api process is running' || echo 'app api process is NOT running' 

    echo '--> app db status:'
    (vagrant ssh -c 'mysql -u app_rw -pkasDFjgr7234DGher78 appdb -e "SELECT DATABASE()";' &> /dev/null) && echo 'app db process is running' || echo 'app db process is NOT running'
}

hello_world ()
{
    curl http://localhost:60510/v1/hello_world
}


run ()
{ # run the functions selected

    # Function requires 1 argument.
    PARAMS=1     
    E_BAD_PARAMS=91

    [ $arglen -eq $PARAMS ] || (echo -e "$(basename "$0"): Bad Argument\n"; usage; exit $E_BAD_PARAMS)

    case "${args[0]}" in
        "up")         
              main
              ;;
        "destroy")    
              destroy
              ;;
        "hello_world")      
              hello_world
              ;;
        "ui")      
              ui
              ;;
        "ut")      
              ut
              ;;
        "pull_mysqldb")      
              pull_mysqldb
              ;;
        "ft")      
              ft
              ;;
        "status")      
              status
              ;;
        "help")      
              usage
              ;;
        *)         
              echo -e "$(basename "$0"): Unknown command!\n"
              usage;
              exit $E_BAD_PARAMS
              ;;
      esac
}

#main
run 
