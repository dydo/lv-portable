# lv-portable

[日本語](README_ja.md)

An unofficial integration of lv 4.51, Debian fixes, lv-mod's Windows support,
and Gentoo's ncurses detection.

**Version: 4.51.portable.1 — release candidate — 2026-11-15**

This is not an official release of lv, lv-mod, Debian, or Gentoo. Interactive
terminal operation has not been fully tested; this version is experimental.

## About lv

lv is a multilingual text viewer and character-encoding conversion filter.
When invoked as `lgrep`, it searches for matching lines in grep mode.

The original lv was written by NARITA Tomio. Windows support comes from
[lv-mod](https://github.com/k-takata/lv-mod) by K.Takata and contributors.

## Integration changes

- Preserve lv-mod's Windows console, process launching, Unicode I/O and UTF-16 support.
- Merge fixes from Debian 4.51-10.1, resolving overlaps to retain Windows and UTF-16 behavior.
- Use pkg-config to detect ncurses on Unix, following Gentoo's patch.
- Replace selected header-level tentative definitions with explicit `extern`
  declarations and single C definitions, avoiding the need for `-fcommon`.
- Restore upstream character conversion tables that were empty in the supplied working tree.
- Gate legacy table regeneration behind maintainer mode so ordinary builds use the distributed tables.
- Install `lv.hlp` beside the Windows executable, matching its help lookup.

Not every Debian patch was applied unchanged. See [CHANGELOG.md](CHANGELOG.md)
and [PROVENANCE.md](PROVENANCE.md) for the changes and input snapshots.

## Release files

| File | Contents |
| --- | --- |
| `lv-portable-4.51.portable.1.tar.gz` | Complete source, build scripts and generated configure |
| `lv-portable-4.51.portable.1-ucrt64.zip` | Windows executables, help and license notices |
| `full-from-upstream-4.51.patch` | Complete file-content delta from upstream `lv_4.51.orig.tar.gz` |
| `SHA256SUMS` | SHA-256 checksums for release assets |
| `validation-results.json` | Recorded validation results |

Use the source archive to reproduce the integration. The full patch can be
applied with `patch -p1` from the root of a clean upstream tree. File permissions
are not represented by that patch; the source archive is authoritative for modes.

## Windows

Extract the UCRT64 ZIP and keep `lv.exe` and `lv.hlp` together. `lgrep.exe`
can be used from the same directory.

The binary uses Windows UCRT and does not require `msys-2.0.dll`. Help is
located relative to the executable, not the current working directory.

### Build with MSYS2 UCRT64

Requires UCRT64 GCC, make and pkg-config. In a UCRT64 terminal, run from the
source root, not from `src`:

```sh
tar xf lv-portable-4.51.portable.1.tar.gz
cd lv-portable-4.51.portable.1
sh ./build-ucrt64.sh
```

The executable is `src/lv.exe`. To test without installing:

```sh
cp lv.hlp src/lv.hlp
./src/lv.exe -h
python tests/smoke.py src/lv.exe
```

The smoke test requires UCRT64 Python 3. To install:

```sh
sh ./build-ucrt64.sh --prefix=/usr/local
make install
```

## Unix / Linux

Requires a C compiler, make, pkg-config and ncurses development files. A normal
build does not need to download character mapping data.

From the source root:

```sh
CFLAGS='-O2 -g -std=gnu17' ./configure --prefix=/usr/local
make
```

`-std=gnu17` avoids incompatibilities between old function declarations and
new GCC defaults. Do not replace the entire configuration with `make CFLAGS=...`.

Install with write permission to the chosen prefix:

```sh
make install
```

Unix help is installed to `$(libdir)/lv/lv.hlp`; that directory is compiled
in as `LV_HELP_PATH`. Use `--prefix=/usr/local` to avoid directly overwriting
the package-managed `/usr/bin/lv`.

### Verify without changing the system installation

On Linux with GNU tar, the build dependencies above and Python 3:

```sh
sh ./check-unix-release.sh
```

This copies the source to a new temporary directory, builds, installs to an
isolated prefix, and tests Japanese conversion and help output. It does not
use sudo or change the system lv. It reports and retains its logs and files.

Use separate extracted source trees for Windows and Unix builds.

## Usage

Display a UTF-8 file on a UTF-8 terminal:

```sh
lv -Iu8 -Ou8 file.txt
```

Automatically detect input encoding and produce UTF-8 output:

```sh
lv -Ou8 file.txt
```

Convert Shift_JIS input to UTF-8:

```sh
lv -Is -Ou8 file.txt > converted.txt
```

Search a UTF-8 file using a UTF-8 pattern:

```sh
lgrep -Iu8 -Ku8 -Ou8 'pattern' file.txt
```

`-I` selects input encoding, `-O` selects output encoding, and `-K` selects
keyboard/pattern encoding. See `lv -h`, `lv.1` and `index.html` for details.

## Validation

| Check | MSYS2 UCRT64 / GCC 16.2.0 | Gentoo Linux / GCC 16.2.1 |
| --- | --- | --- |
| Compile and link | Passed | Passed |
| Staged / isolated installation | Passed | Passed |
| Japanese UTF-8 to UTF-8 | Passed | Passed |
| Japanese CP932 to UTF-8 | Passed | Passed |
| Japanese BOM UTF-16 to UTF-8 | Passed | Passed |
| Help output | Passed | Passed |

Windows builds without `-fcommon`. Gentoo links `libncurses.so.6` and
`libtinfo.so.6`. The conversion test normalizes Windows CRLF output to LF.

Interactive key handling, all compression formats, large-file limits and
other OS/compiler combinations remain untested. No security audit has been
performed. Linux/Windows GitHub Actions jobs are included but have not been
run on hosted runners. See [VALIDATION.md](VALIDATION.md) and the accompanying
`validation-results.json`.

## Regenerating configure

Generated `configure` and `Makefile.in` files are included. When regeneration
is needed, install Autoconf, Automake and pkg-config, then run from the root:

```sh
autoreconf -fi
```

`--enable-maintainer-mode` enables legacy table-regeneration rules requiring
external mapping data. It is not needed for ordinary builds or use.

## License and sources

The original lv source notices permit redistribution under GNU GPL version 2
or later. They are retained, and the GPL v2 text is in `GPL.txt`. See
[LICENSES.md](LICENSES.md) for individual components such as iscygpty and
the Debian/Gentoo changes.

When redistributing binaries, also provide their corresponding complete
source and license notices. Identify this as an unofficial integration,
not a release endorsed by the original authors or source projects.

- [lv-mod](https://github.com/k-takata/lv-mod)
- [Debian lv](https://packages.debian.org/source/sid/lv)
- [Gentoo lv](https://packages.gentoo.org/packages/app-text/lv)

Input snapshots, including local modifications and file hashes, are documented
in [PROVENANCE.md](PROVENANCE.md) and `input-manifest.json` in the source archive.
