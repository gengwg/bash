# bash

bash script examples

## Use a string containing quotes in a command option

The best way to do this sort of thing is using an array instead of a simple text variable:

```
GITFLAGS=(-c core.sshCommand="/usr/bin/ssh -i /home/gengwg/.ssh/ghe-deploy-key")
```

Then in the command use it like this:

```
    ${GITCMD} "${GITFLAGS[@]}" tag -a snapshot-${YMD} -m "snapshot ${YMD}"
    ${GITCMD} "${GITFLAGS[@]}" push origin main --tags
```

## List of Commands

```
# command1 && command2
# command2 is executed if, and only if, command1 returns an exit status of zero (success).

$ true && echo "Things went well"
Things went well

$ false && echo "Will not be printed"
$

# command1 || command2
# command2 is executed if, and only if, command1 returns a non-zero exit status.

$ false || echo "Oops, fail"
Oops, fail

$ true || echo "Will not be printed"
$

$ true ; echo "This will always run"
This will always run

$ false ; echo "This will always run"
This will always run
```

One can test conditions by `eval`:

```
$ a=2

$ eval [ "$a" -eq 2 ]
$ echo $?
0 # true

$ eval [ "$a" -eq 3 ]
$ echo $?
1 # false
```

Or simply run an example with your condition:

```
$ [ "$a" -eq 2 ] && echo hello
hello
$ [ "$a" -eq 3 ] && echo hello
$
```