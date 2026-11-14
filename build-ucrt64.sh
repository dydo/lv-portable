#!/bin/sh
set -eu
cd "$(dirname "$0")"
export PATH=/ucrt64/bin:/usr/bin:$PATH
export CONFIG_SITE=/dev/null
: "${CFLAGS:=-O2 -g -std=gnu17}"
export CFLAGS
./configure --host=x86_64-w64-mingw32 --prefix=/usr/local "$@"
make -j4
