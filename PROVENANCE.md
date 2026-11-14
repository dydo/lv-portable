# Source provenance

This release was integrated from local source snapshots, not from clean
upstream checkouts. The input manifest records exact file hashes of the
inputs used; the lv-mod checkout had local changes.

- Common base: https://deb.debian.org/debian/pool/main/l/lv/lv_4.51.orig.tar.gz
- Debian packaging reference: version 4.51-10.1,
  https://deb.debian.org/debian/pool/main/l/lv/lv_4.51-10.1.debian.tar.xz .
  The supplied Debian source tree already had these patches and Gentoo's
  ncurses detection applied. Reference patches are included, not automatically
  applied a second time by this build.
- Windows base: https://github.com/k-takata/lv-mod ; the supplied checkout
  pointed at ae96849059bac6351af9d5493ab792af458eeb64 (tag lv-4.51.d),
  with additional local changes. This is not an assertion of a clean checkout.
- Gentoo ncurses patch:
  https://github.com/gentoo/gentoo/blob/master/app-text/lv/files/lv-tinfo.patch

Patch merging used upstream 4.51 as the base, the supplied lv-mod tree as one
side and the supplied Debian tree as the other. Conflicts were resolved as
described in CHANGELOG.md. Documentation retains the lv-mod-specific options.
The delivered full source is the authoritative integration, not the old
partial source-changes.diff from the prototype.

input-manifest.json records the source/build input snapshots and reference
archive SHA-256 hashes. Generated configure and Makefile.in are included.
