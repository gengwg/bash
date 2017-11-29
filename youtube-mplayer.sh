#!/usr/bin/env bash
# Play youtube video using mplayer in terminal.
# Useful for playing music from youtube.
#
# Usage:
#     ./youtube-mplayer.sh https://www.youtube.com/watch?v=dyFYJclrSAc
youtube-dl -q -o- "$*" | mplayer -novideo -af scaletempo  -softvol -softvol-max 400  -cache 8192  -
