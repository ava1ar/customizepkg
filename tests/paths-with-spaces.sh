#!/bin/bash

set -eu

CUSTOMIZEPKG=$(realpath "$(dirname "$0")/../customizepkg")
TESTDIR=$(mktemp -d)
trap 'rm -rf "$TESTDIR"' EXIT

CONFIGDIR="$TESTDIR/config with spaces"
mkdir -p "$CONFIGDIR/demo.files" "$TESTDIR/package"

cat > "$TESTDIR/package/PKGBUILD" <<'EOF'
pkgname=demo
pkgver=1
source=()
sha256sums=()
EOF
printf '# Add the files in demo.files.\n' > "$CONFIGDIR/demo"
printf 'file contents\n' > "$CONFIGDIR/demo.files/file with spaces.txt"

(
	cd "$TESTDIR/package"
	CUSTOMIZEPKG_CONFIG="$CONFIGDIR" "$CUSTOMIZEPKG" --modify --quiet
)

cmp "$CONFIGDIR/demo.files/file with spaces.txt" "$TESTDIR/package/file with spaces.txt"
grep -Fq "'file with spaces.txt'" "$TESTDIR/package/PKGBUILD"
grep -Fq "'$(sha256sum "$CONFIGDIR/demo.files/file with spaces.txt" | cut -d' ' -f1)'" \
	"$TESTDIR/package/PKGBUILD"
