#!/bin/bash

set -eu

CUSTOMIZEPKG=$(realpath "$(dirname "$0")/../customizepkg")
TESTDIR=$(mktemp -d)
trap 'rm -rf "$TESTDIR"' EXIT

run_failure_test()
{
	local rule=$1

	rm -rf "$TESTDIR/config"
	mkdir -p "$TESTDIR/config"
	printf 'pkgname=demo\npkgver=1\n' > "$TESTDIR/PKGBUILD"
	printf '%s\n' "$rule" > "$TESTDIR/config/demo"

	if (
		cd "$TESTDIR"
		CUSTOMIZEPKG_CONFIG="$TESTDIR/config" "$CUSTOMIZEPKG" --modify --silence
	); then
		echo "customizepkg unexpectedly accepted: $rule" 1>&2
		return 1
	fi

	grep -Fxq 'pkgver=1' "$TESTDIR/PKGBUILD"
	test ! -e "$TESTDIR/PKGBUILD.original"
}

run_failure_test 'patch#pkgbuild#missing.patch'
run_failure_test 'replace#global#[#value'
run_failure_test 'not-an-action#global#pattern'
