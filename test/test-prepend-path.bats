#!/usr/bin/env bats

# vim: ft=sh

load setup

setup() {
	[ -z "$TMPDIR" ] && TMPDIR=/tmp
	export DIR="$TMPDIR/test-path.$$"
	mkdir -p "$DIR"
	mkdir -p "$DIR/dir1/dir11"
	mkdir -p "$DIR/dir2"
	mkdir -p "$DIR/dir20"
	export PATH_SAVED="$PATH"
	export PATH=
}

teardown() {
	export PATH="$PATH_SAVED"
	rm -r "$DIR"
}

# Reset everything

@test "ignore nonexistent directories" {
	__prepend_to_path "$DIR/nonexistent"
	[ "$PATH" = "" ]
}

@test "add first entry" {
	__prepend_to_path "$DIR/dir1"
	[ "$PATH" = "$DIR/dir1" ]
}

@test "duplicate check: only entry" {
	__prepend_to_path "$DIR/dir1"
	__prepend_to_path "$DIR/dir1"
	[ "$PATH" = "$DIR/dir1" ]
}

@test "add second entry" {
	__prepend_to_path "$DIR/dir1"
	__prepend_to_path "$DIR/dir2"
	[ "$PATH" = "$DIR/dir2:$DIR/dir1" ]
}

@test "duplicate check: at beginning" {
	__prepend_to_path "$DIR/dir1"
	__prepend_to_path "$DIR/dir2"
	__prepend_to_path "$DIR/dir2"
	[ "$PATH" = "$DIR/dir2:$DIR/dir1" ]
}

@test "duplicate check: at end" {
	__prepend_to_path "$DIR/dir1"
	__prepend_to_path "$DIR/dir2"
	__prepend_to_path "$DIR/dir1"
	[ "$PATH" = "$DIR/dir2:$DIR/dir1" ]
}

@test "duplicate check: dirs with same prefix are not equal (1)" {
	__prepend_to_path "$DIR/dir1"
	__prepend_to_path "$DIR/dir2"
	__prepend_to_path "$DIR/dir1/dir11"
	[ "$PATH" = "$DIR/dir1/dir11:$DIR/dir2:$DIR/dir1" ]
}

@test "duplicate check: dirs with same prefix are not equal (2)" {
	__prepend_to_path "$DIR/dir1"
	__prepend_to_path "$DIR/dir2"
	__prepend_to_path "$DIR/dir1/dir11"
	__prepend_to_path "$DIR/dir20"
	[ "$PATH" = "$DIR/dir20:$DIR/dir1/dir11:$DIR/dir2:$DIR/dir1" ]
}

@test "duplicate check: in middle" {
	__prepend_to_path "$DIR/dir1"
	__prepend_to_path "$DIR/dir2"
	__prepend_to_path "$DIR/dir1/dir11"
	__prepend_to_path "$DIR/dir20"
	__prepend_to_path "$DIR/dir2"
	[ "$PATH" = "$DIR/dir20:$DIR/dir1/dir11:$DIR/dir2:$DIR/dir1" ]
}
