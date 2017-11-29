#!/usr/bin/env bash
# Usage:
#     ./youtube-mplayer.sh https://www.youtube.com/watch?v=dyFYJclrSAc
youtube-dl -q -o- "$*" | mplayer -novideo -af scaletempo  -softvol -softvol-max 400  -cache 8192  -
