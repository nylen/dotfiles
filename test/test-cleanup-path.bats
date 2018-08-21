#!/usr/bin/env bats

# vim: ft=sh

load setup
# don't break assertion evaluation
LT="<"
GT=">"

@test "cleanup home directory" {
	cleaned=$(__cleanup_path "$HOME")
    [ "$cleaned" = "~" ]
}

@test "cleanup home directory (trailing slash)" {
	cleaned=$(__cleanup_path "$HOME/")
    [ "$cleaned" = "~" ]
}

@test "cleanup subdirectory of home directory" {
	cleaned=$(__cleanup_path "$HOME/dotfiles")
    [ "$cleaned" = "~/dotfiles" ]
}

@test "cleanup subdirectory of home directory (trailing slash)" {
	cleaned=$(__cleanup_path "$HOME/dotfiles/")
    [ "$cleaned" = "~/dotfiles" ]
}

@test "cleanup directory with short alias" {
	__add_path_alias "~/dotfiles/.git" DOT-GIT
	cleaned=$(__cleanup_path ~/dotfiles/.git)
	[ "$cleaned" = "${LT}DOT-GIT${GT}" ]
}

@test "cleanup directory with short alias (trailing slashes)" {
	__add_path_alias ~/dotfiles/.git/ DOT-GIT
	cleaned=$(__cleanup_path ~/dotfiles/.git/)
	[ "$cleaned" = "${LT}DOT-GIT${GT}" ]
}

@test "cleanup subdirectory of directory with short alias" {
	__add_path_alias ~/dotfiles/.git DOT-GIT
	cleaned=$(__cleanup_path ~/dotfiles/.git/hooks)
	[ "$cleaned" = "${LT}DOT-GIT${GT}/hooks" ]
}

@test "cleanup subdirectory of directory with short alias (trailing slashes)" {
	__add_path_alias ~/dotfiles/.git/ DOT-GIT
	cleaned=$(__cleanup_path ~/dotfiles/.git/hooks/)
	[ "$cleaned" = "${LT}DOT-GIT${GT}/hooks" ]
}
