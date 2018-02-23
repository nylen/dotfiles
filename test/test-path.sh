#!/bin/bash

cd "$(dirname "$0")"
. setup.sh

[ -z "$TMPDIR" ] && TMPDIR=/tmp
DIR="$TMPDIR/test-path.$$"
mkdir -p "$DIR"
mkdir -p "$DIR/dir1/dir11"
mkdir -p "$DIR/dir2"
mkdir -p "$DIR/dir20"
export PATH_SAVED="$PATH"

test_cleanup() {
	export PATH="$PATH_SAVED"
	rm -r "$DIR"
}

# Reset everything
export PATH=

__prepend_to_path "$DIR/nonexistent"
# Ignore nonexistent directories
assert_equal "$PATH" ""

__prepend_to_path "$DIR/dir1"
# Add first entry
assert_equal "$PATH" "$DIR/dir1"

__prepend_to_path "$DIR/dir1"
# Duplicate check: only entry
assert_equal "$PATH" "$DIR/dir1"

__prepend_to_path "$DIR/dir2"
# Add second entry
assert_equal "$PATH" "$DIR/dir2:$DIR/dir1"

__prepend_to_path "$DIR/dir2"
# Duplicate check: at beginning
assert_equal "$PATH" "$DIR/dir2:$DIR/dir1"

__prepend_to_path "$DIR/dir1"
# Duplicate check: at end
assert_equal "$PATH" "$DIR/dir2:$DIR/dir1"

__prepend_to_path "$DIR/dir1/dir11"
# Duplicate check: dirs with same prefix are not equal (1)
assert_equal "$PATH" "$DIR/dir1/dir11:$DIR/dir2:$DIR/dir1"

__prepend_to_path "$DIR/dir20"
# Duplicate check: dirs with same prefix are not equal (2)
assert_equal "$PATH" "$DIR/dir20:$DIR/dir1/dir11:$DIR/dir2:$DIR/dir1"

__prepend_to_path "$DIR/dir2"
# Duplicate check: in middle
assert_equal "$PATH" "$DIR/dir20:$DIR/dir1/dir11:$DIR/dir2:$DIR/dir1"
