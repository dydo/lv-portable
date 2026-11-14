# Validation status

Release candidate 4.51.portable.1 was built from the distributed source with
MSYS2 UCRT64 GCC 16.2.0 and Gentoo Linux GCC 16.2.1 (20260926).
Both builds, isolated installs, Japanese UTF-8/CP932/BOM UTF-16 input to UTF-8
output, and help display passed. Windows was built without -fcommon.
Gentoo linked libncurses.so.6 and libtinfo.so.6.
No installed system lv was overwritten.

Not yet validated: interactive paging/key handling, all compression formats,
large-file limits, other Unix systems, or other Windows toolchains.
Hosted GitHub Actions Linux and Windows builds and smoke tests passed for
commit a49e2cd: https://github.com/dydo/lv-portable/actions/runs/43617125778

Final asset hashes and patch reproduction results are in the accompanying
validation-results.json and SHA256SUMS. Documentation was updated after the
Linux smoke test; the executable C sources were unchanged by that update.
