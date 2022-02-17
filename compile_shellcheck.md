# Compile ShellCheck on Macbook

Followed [here](https://github.com/koalaman/shellcheck#compiling-from-source).

## Installing Cabal

```
gengwg@gengwg-mbp:~$ brew install cabal-install
==> Downloading https://ghcr.io/v2/homebrew/core/ghc/manifests/8.10.7_1
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/ghc/blobs/sha256:68f447996de80ef0aa655b9b0f5cc048503a09366b17edf77b101f9c1a38fe0b
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:68f447996de80ef0aa655b9b0f5cc048503a09366b17edf77b101f9c1a38fe0b?se=2022-02
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/cabal-install/manifests/3.6.2.0
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/cabal-install/blobs/sha256:e7afa39e11ae84407293ea3baefb4587c56d682c9d705dc9649aa3f77c33a1b6
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:e7afa39e11ae84407293ea3baefb4587c56d682c9d705dc9649aa3f77c33a1b6?se=2022-02
######################################################################## 100.0%
==> Installing dependencies for cabal-install: ghc
==> Installing cabal-install dependency: ghc
==> Pouring ghc--8.10.7_1.big_sur.bottle.tar.gz
==> /usr/local/Cellar/ghc/8.10.7_1/bin/ghc-pkg recache
🍺  /usr/local/Cellar/ghc/8.10.7_1: 6,913 files, 1.5GB
==> Installing cabal-install
==> Pouring cabal-install--3.6.2.0.big_sur.bottle.tar.gz
🍺  /usr/local/Cellar/cabal-install/3.6.2.0: 7 files, 39.7MB
==> `brew cleanup` has not been run in the last 30 days, running now...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
Removing: /Users/gengwg/Library/Logs/Homebrew/go... (64B)
Removing: /Users/gengwg/Library/Logs/Homebrew/ipcalc... (64B)
Removing: /Users/gengwg/Library/Logs/Homebrew/kubebuilder... (64B)
Removing: /Users/gengwg/Library/Logs/Homebrew/tilt... (64B)
Removing: /Users/gengwg/Library/Logs/Homebrew/krew... (64B)
Pruned 1 symbolic links from /usr/local

gengwg@gengwg-mbp:~$ cabal update
Config file path source is default config file.
Config file /Users/gengwg/.cabal/config not found.
Writing default configuration to /Users/gengwg/.cabal/config
Downloading the latest package list from hackage.haskell.org
Updated package list of hackage.haskell.org to the index-state 2022-02-16T04:23:23Z
```

## Clone and Compile

```
gengwg@gengwg-mbp:~$ git clone git@github.com:koalaman/shellcheck.git
Cloning into 'shellcheck'...
Enter passphrase for key '/Users/gengwg/.ssh/id_rsa':
remote: Enumerating objects: 8346, done.
remote: Counting objects: 100% (577/577), done.
remote: Compressing objects: 100% (188/188), done.
remote: Total 8346 (delta 328), reused 521 (delta 312), pack-reused 7769
Receiving objects: 100% (8346/8346), 4.88 MiB | 6.60 MiB/s, done.
Resolving deltas: 100% (5066/5066), done.
gengwg@gengwg-mbp:~$ cd shellcheck/

gengwg@gengwg-mbp:~/shellcheck$ cabal install
Wrote tarball sdist to
/Users/gengwg/shellcheck/dist-newstyle/sdist/ShellCheck-0.8.0.tar.gz
Resolving dependencies...
Build profile: -w ghc-8.10.7 -O1
In order, the following will be built (use -v for more details):
....
Starting     ShellCheck-0.8.0 (lib)
Building     ShellCheck-0.8.0 (lib)
Installing   ShellCheck-0.8.0 (lib)
Completed    ShellCheck-0.8.0 (lib)
Starting     ShellCheck-0.8.0 (exe:shellcheck)
Building     ShellCheck-0.8.0 (exe:shellcheck)
Installing   ShellCheck-0.8.0 (exe:shellcheck)
Completed    ShellCheck-0.8.0 (exe:shellcheck)
Symlinking 'shellcheck' to '/Users/gengwg/.cabal/bin/shellcheck'
```

Verify complied:

```
gengwg@gengwg-mbp:~/shellcheck$ /Users/gengwg/.cabal/bin/shellcheck -h
unrecognized option `-h'

Usage: shellcheck [OPTIONS...] FILES...
  -a                  --check-sourced            Include warnings from sourced files
  -C[WHEN]            --color[=WHEN]             Use color (auto, always, never)
  -i CODE1,CODE2..    --include=CODE1,CODE2..    Consider only given types of warnings
  -e CODE1,CODE2..    --exclude=CODE1,CODE2..    Exclude types of warnings
  -f FORMAT           --format=FORMAT            Output format (checkstyle, diff, gcc, json, json1, quiet, tty)
                      --list-optional            List checks disabled by default
                      --norc                     Don't look for .shellcheckrc files
  -o check1,check2..  --enable=check1,check2..   List of optional checks to enable (or 'all')
  -P SOURCEPATHS      --source-path=SOURCEPATHS  Specify path when looking for sourced files ("SCRIPTDIR" for script's dir)
  -s SHELLNAME        --shell=SHELLNAME          Specify dialect (sh, bash, dash, ksh)
  -S SEVERITY         --severity=SEVERITY        Minimum severity of errors to consider (error, warning, info, style)
  -V                  --version                  Print version information
  -W NUM              --wiki-link-count=NUM      The number of wiki links to show, when applicable
  -x                  --external-sources         Allow 'source' outside of FILES
                      --help                     Show this usage summary and exit

gengwg@gengwg-mbp:~/shellcheck$ /Users/gengwg/.cabal/bin/shellcheck -V
ShellCheck - shell script analysis tool
version: 0.8.0
license: GNU General Public License, version 3
website: https://www.shellcheck.net
```

Add path:

```
gengwg@gengwg-mbp:~$ export PATH="$HOME/.cabal/bin:$PATH"
gengwg@gengwg-mbp:~$ which shellcheck
/Users/gengwg/.cabal/bin/shellcheck
```

Create a test script:

```
gengwg@gengwg-mbp:~$ vim test.sh
gengwg@gengwg-mbp:~$ cat test.sh
#!/bin/bash
curl https://[2620:10d:c0a8:2b::127]/
gengwg@gengwg-mbp:~$ shellcheck test.sh

In test.sh line 2:
curl -k https://[2620:10d:c0a8:2b::127]/
                ^---------------------^ SC2102 (info): Ranges can only match single chars (mentioned due to duplicates).

For more information:
  https://www.shellcheck.net/wiki/SC2102 -- Ranges can only match single char...
```

## Making changes

Make sure tests pass:

```
gengwg@gengwg-mbp:~/shellcheck$ vim src/ShellCheck/Analytics.hs
gengwg@gengwg-mbp:~/shellcheck$ cabal test
Build profile: -w ghc-8.10.7 -O1
In order, the following will be built (use -v for more details):
 - ShellCheck-0.8.0 (lib) (file src/ShellCheck/Analytics.hs changed)
 - ShellCheck-0.8.0 (test:test-shellcheck) (dependency rebuilt)
Preprocessing library for ShellCheck-0.8.0..
Building library for ShellCheck-0.8.0..
[21 of 23] Compiling ShellCheck.Analytics ( src/ShellCheck/Analytics.hs, /Users/gengwg/shellcheck/dist-newstyle/build/x86_64-osx/ghc-8.10.7/ShellCheck-0.8.0/build/ShellCheck/Analytics.o, /Users/gengwg/shellcheck/dist-newstyle/build/x86_64-osx/ghc-8.10.7/ShellCheck-0.8.0/build/ShellCheck/Analytics.dyn_o )
[23 of 23] Compiling ShellCheck.Checker ( src/ShellCheck/Checker.hs, /Users/gengwg/shellcheck/dist-newstyle/build/x86_64-osx/ghc-8.10.7/ShellCheck-0.8.0/build/ShellCheck/Checker.o, /Users/gengwg/shellcheck/dist-newstyle/build/x86_64-osx/ghc-8.10.7/ShellCheck-0.8.0/build/ShellCheck/Checker.dyn_o ) [TH]
Preprocessing test suite 'test-shellcheck' for ShellCheck-0.8.0..
Building test suite 'test-shellcheck' for ShellCheck-0.8.0..
[1 of 1] Compiling Main             ( test/shellcheck.hs, /Users/gengwg/shellcheck/dist-newstyle/build/x86_64-osx/ghc-8.10.7/ShellCheck-0.8.0/t/test-shellcheck/build/test-shellcheck/test-shellcheck-tmp/Main.o ) [ShellCheck.Analytics changed]
Linking /Users/gengwg/shellcheck/dist-newstyle/build/x86_64-osx/ghc-8.10.7/ShellCheck-0.8.0/t/test-shellcheck/build/test-shellcheck/test-shellcheck ...
Running 1 test suites...
Test suite test-shellcheck: RUNNING...
Test suite test-shellcheck: PASS
Test suite logged to:
/Users/gengwg/shellcheck/dist-newstyle/build/x86_64-osx/ghc-8.10.7/ShellCheck-0.8.0/t/test-shellcheck/test/ShellCheck-0.8.0-test-shellcheck.log
1 of 1 test suites (1 of 1 test cases) passed.
```

Install new binary:

```
gengwg@gengwg-mbp:~/shellcheck$ cabal install
Wrote tarball sdist to
/Users/gengwg/shellcheck/dist-newstyle/sdist/ShellCheck-0.8.0.tar.gz
Resolving dependencies...
Build profile: -w ghc-8.10.7 -O1
In order, the following will be built (use -v for more details):
 - ShellCheck-0.8.0 (lib) (requires build)
 - ShellCheck-0.8.0 (exe:shellcheck) (requires build)
Starting     ShellCheck-0.8.0 (lib)
Building     ShellCheck-0.8.0 (lib)
Installing   ShellCheck-0.8.0 (lib)
Completed    ShellCheck-0.8.0 (lib)
Starting     ShellCheck-0.8.0 (exe:shellcheck)
Building     ShellCheck-0.8.0 (exe:shellcheck)
Installing   ShellCheck-0.8.0 (exe:shellcheck)
Completed    ShellCheck-0.8.0 (exe:shellcheck)
Symlinking 'shellcheck' to '/Users/gengwg/.cabal/bin/shellcheck'
cabal: Path '/Users/gengwg/.cabal/bin/shellcheck' already exists. Use
--overwrite-policy=always to overwrite.

gengwg@gengwg-mbp:~/shellcheck$ cabal install --overwrite-policy=always
Wrote tarball sdist to
/Users/gengwg/shellcheck/dist-newstyle/sdist/ShellCheck-0.8.0.tar.gz
Resolving dependencies...
Up to date
Symlinking 'shellcheck' to '/Users/gengwg/.cabal/bin/shellcheck'
```

Verify Changes:

```
gengwg@gengwg-mbp:~/shellcheck$ shellcheck ~/test.sh

In /Users/gengwg/test.sh line 2:
curl https://[2620:10d:c0a8:2b::127]/
             ^---------------------^ SC2102 (info): 2620:10d:c0a8:2b::127

For more information:
  https://www.shellcheck.net/wiki/SC2102 -- 2620:10d:c0a8:2b::127
```

Make new changes and install again:

```
gengwg@gengwg-mbp:~/shellcheck$ cabal install --overwrite-policy=always
Wrote tarball sdist to
/Users/gengwg/shellcheck/dist-newstyle/sdist/ShellCheck-0.8.0.tar.gz
Resolving dependencies...
Build profile: -w ghc-8.10.7 -O1
In order, the following will be built (use -v for more details):
 - ShellCheck-0.8.0 (lib) (requires build)
 - ShellCheck-0.8.0 (exe:shellcheck) (requires build)
Starting     ShellCheck-0.8.0 (lib)
Building     ShellCheck-0.8.0 (lib)
Installing   ShellCheck-0.8.0 (lib)
Completed    ShellCheck-0.8.0 (lib)
Starting     ShellCheck-0.8.0 (exe:shellcheck)
Building     ShellCheck-0.8.0 (exe:shellcheck)
Installing   ShellCheck-0.8.0 (exe:shellcheck)
Completed    ShellCheck-0.8.0 (exe:shellcheck)
Symlinking 'shellcheck' to '/Users/gengwg/.cabal/bin/shellcheck'
gengwg@gengwg-mbp:~/shellcheck$ shellcheck ~/test.sh

In /Users/gengwg/test.sh line 2:
curl https://[2620:10d:c0a8:2b::127]/
             ^---------------------^ SC2102 (info): True

For more information:
  https://www.shellcheck.net/wiki/SC2102 -- True
```

An example change/PR see [here](https://github.com/koalaman/shellcheck/pull/2452).
