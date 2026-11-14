#!/bin/sh
# Build an extracted release in a new temporary directory without sudo.
set -eu
source_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
for tool in cc make pkg-config python3 tar; do
    command -v "$tool" >/dev/null 2>&1 || { printf '%s\n' "Missing tool: $tool" >&2; exit 1; }
done
pkg-config --exists ncurses
check_dir=$(mktemp -d "${TMPDIR:-/tmp}/lv-portable-check.XXXXXX")
printf 'Verification directory: %s\n' "$check_dir"
mkdir "$check_dir/source"
# Copy source files, excluding any prior build products in the supplied tree.
tar -C "$source_dir" --exclude='./.git' --exclude='./stage' \
    --exclude='./autom4te.cache' --exclude='*.o' --exclude='*.exe' \
    --exclude='*.tar.gz' --exclude='./Makefile' --exclude='./src/Makefile' \
    --exclude='./config.status' --exclude='./config.cache' --exclude='./config.log' \
    --exclude='./src/.deps' -cf "$check_dir/source.tar" .
tar -C "$check_dir/source" -xf "$check_dir/source.tar"
cd "$check_dir/source"
cc --version > "$check_dir/compiler.txt"
CFLAGS='-O2 -g -std=gnu17' ./configure --prefix="$check_dir/install" \
    > "$check_dir/configure.log" 2>&1
make -j2 > "$check_dir/build.log" 2>&1
make install > "$check_dir/install.log" 2>&1
python3 tests/smoke.py "$check_dir/install/bin/lv" > "$check_dir/smoke.log" 2>&1
if command -v ldd >/dev/null 2>&1; then
    ldd "$check_dir/install/bin/lv" > "$check_dir/ldd.txt"
fi
cat "$check_dir/smoke.log"
printf 'PASS; logs and installed test binary are in %s\n' "$check_dir"
