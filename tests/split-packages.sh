#!/bin/bash

set -eu

CUSTOMIZEPKG=$(realpath "$(dirname "$0")/../customizepkg")
TESTDIR=$(mktemp -d)
trap 'rm -rf "$TESTDIR"' EXIT

mkdir -p "$TESTDIR/config"
cat > "$TESTDIR/PKGBUILD" <<'EOF'
pkgname=(one two)
pkgver=1
EOF
cp "$TESTDIR/PKGBUILD" "$TESTDIR/expected-original"

cat > "$TESTDIR/config/one" <<'EOF'
#!/bin/bash
printf '\n# one\n' >> "$2"
EOF
cat > "$TESTDIR/config/two" <<'EOF'
#!/bin/bash
printf '\n# two\n' >> "$2"
EOF
chmod +x "$TESTDIR/config/one" "$TESTDIR/config/two"

(
	cd "$TESTDIR"
	CUSTOMIZEPKG_CONFIG="$TESTDIR/config" "$CUSTOMIZEPKG" --modify --silence
)

grep -Fxq '# one' "$TESTDIR/PKGBUILD"
grep -Fxq '# two' "$TESTDIR/PKGBUILD"
cmp "$TESTDIR/expected-original" "$TESTDIR/PKGBUILD.original"
test ! -e "$TESTDIR/PKGBUILD.custom"

rm "$TESTDIR/config/one" "$TESTDIR/config/two"
cp "$TESTDIR/expected-original" "$TESTDIR/PKGBUILD"
rm "$TESTDIR/PKGBUILD.original"

(
	cd "$TESTDIR"
	CUSTOMIZEPKG_CONFIG="$TESTDIR/config" "$CUSTOMIZEPKG" --modify --silence
)

cmp "$TESTDIR/expected-original" "$TESTDIR/PKGBUILD"
test ! -e "$TESTDIR/PKGBUILD.custom"
