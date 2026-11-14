# Integration changes

## Unreleased — 2026-11-15

- Include the terminal library's termcap.h instead of declaring its functions
  with empty parameter lists, which mean no parameters in C23.
- Match the termcap string buffer pointer to the library's char ** parameter.
- Allow CFLAGS to be supplied to check-unix-release.sh so newer C language
  modes can be verified without changing the helper script.
- Verified clean builds, isolated installs and Japanese conversion/help smoke
  tests with Gentoo GCC 16.2.1 defaults and with explicit GNU17.

## 4.51.portable.1 — 2026-11-15 (release candidate)

- Start with the supplied lv-mod Windows/UTF-16 code and merge Debian's
  applied 4.51 fixes using the original lv 4.51 archive as a three-way base.
- Preserve Windows console, process launching, temporary files, Unicode I/O,
  and UTF-16 handling when resolving overlapping Debian edits.
- Keep Debian's signal interface update, escape-K fix, filename display fix,
  and compression support where compatible; preserve lv-mod behavior where
  its UTF-16 and file-buffer changes overlap.
- Detect ncurses via pkg-config for Unix, as in Gentoo's lv-tinfo.patch.
  Skip Unix terminal library checks for MinGW targets.
- Replace header-level tentative definitions for command state and Unicode
  width/unification state with extern declarations and single C definitions.
- Remove inline from the two internal input-buffer function declarations
  and definitions, following the intent of Debian's no_inline fix.
- Restore upstream .map/.rev tables: the supplied lv-mod tree contained empty
  tables. Use zcat for MinGW/MSYS environments and retain BSD gzcat behavior.
- Install lv.hlp beside the Windows executable to match its module-relative
  lookup. Unix uses LV_HELP_PATH. No claim that a native Windows executable
  resolves MSYS virtual /usr paths is made.
- Gate old table-regeneration rules behind maintainer mode so a normal build
  cannot replace distributed tables using absent or damaged downloaded data.
- Remove a local-only helper script and legacy packaging script; add build
  instructions, provenance, smoke checks and a proposed Linux/Windows CI job.
- Retain all existing attribution and license notices. This is not a claim
  that every Debian hunk was applied unchanged.
