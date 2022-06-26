#!/bin/bash

# The until loop is used to execute a given set of commands as long as the given condition evaluates to false.

# The condition is evaluated before executing the commands. 
# If the condition evaluates to false, commands are executed. 
# Otherwise, if the condition evaluates to true the loop will be terminated 
# and the program control will be passed to the command that follows.

counter=0

until [ $counter -gt 5 ]
do
  echo Counter: $counter
  ((counter++))
done

# $ until false; do echo 'xxx'; sleep 2; done
