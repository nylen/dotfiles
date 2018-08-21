#!/usr/bin/env bats

# vim: ft=sh

load setup

@test "default hook functions" {
	[ "$__hook_functions_chpwd" = ":__hook_chpwd_check_nvmrc:" ]
}

@test "multiple hook functions" {
	__add_hook chpwd "__hook_some_function"
	[ "$__hook_functions_chpwd" = ":__hook_chpwd_check_nvmrc:__hook_some_function:" ]
}

@test "reset and add single hook function" {
	export __hook_functions_chpwd=
	__add_hook chpwd "__hook_some_function_2"
	[ "$__hook_functions_chpwd" = ":__hook_some_function_2:" ]
}
