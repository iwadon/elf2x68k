#!/bin/sh
set -e
PATH="/Users/don/local/opt/coreutils/libexec/gnubin:$PATH"
PATH="/Users/don/local/opt/make/libexec/gnubin:$PATH"
make $*
