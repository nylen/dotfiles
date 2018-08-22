#!/usr/bin/env bats

# vim: ft=sh

load setup

setup() {
	__path_alias_dirs=()
	__path_alias_aliases=()
	__add_path_alias ~/dotfiles/.git DOT-GIT
}

@test "list path aliases" {
	run __cd_path_alias
	[ $status -eq 0 ]
	[ ${#lines[@]} -eq 2 ]
	[ "${lines[0]}" = 'Registered path aliases:' ]
	[ "${lines[1]}" = "$(printf 'DOT-GIT\t~/dotfiles/.git/')" ]
}

@test "change to path alias" {
	__cd_path_alias DOT-GIT
	[ $? -eq 0 ]
	[ "$(pwd)" = ~/dotfiles/.git ]
	# Verify that shopt nocasematch was reset
	[ "$(shopt -p nocasematch)" = 'shopt -u nocasematch' ]
	# Verify output
	run __cd_path_alias DOT-GIT
	[ $status -eq 0 ]
	[ ${#lines[@]} -eq 1 ]
	[ "${lines[0]}" = ~/dotfiles/.git/ ]
}

@test "change to path alias (case-insensitive)" {
	__cd_path_alias dot-git
	[ $? -eq 0 ]
	[ "$(pwd)" = ~/dotfiles/.git ]
	# Verify that shopt nocasematch was reset
	[ "$(shopt -p nocasematch)" = 'shopt -u nocasematch' ]
}

@test "change to path alias (shopt -s nocasematch)" {
	shopt -s nocasematch
	__cd_path_alias DOT-GIT
	[ $? -eq 0 ]
	[ "$(pwd)" = ~/dotfiles/.git ]
	# Verify that shopt nocasematch was reset
	[ "$(shopt -p nocasematch)" = 'shopt -s nocasematch' ]
}

@test "change to path alias (invalid)" {
	__cd_path_alias xxx || true
	[ "$(pwd)" = ~/dotfiles ]
	# Verify that shopt nocasematch was reset
	[ "$(shopt -p nocasematch)" = 'shopt -u nocasematch' ]
	# Verify output and exit code
	run __cd_path_alias xxx
	[ $status -eq 1 ]
	[ ${#lines[@]} -eq 1 ]
	[ "${lines[0]}" = 'Path alias not recognized: xxx' ]
}
