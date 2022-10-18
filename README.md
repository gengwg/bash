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

