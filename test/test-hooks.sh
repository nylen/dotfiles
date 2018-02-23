#!/bin/bash

cd "$(dirname "$0")"
. setup.sh

assert_equal "$__hook_functions_chpwd" ":__hook_chpwd_check_nvmrc:"

__add_hook chpwd "__hook_some_function"
assert_equal "$__hook_functions_chpwd" ":__hook_chpwd_check_nvmrc:__hook_some_function:"

export __hook_functions_chpwd=
assert_equal "$__hook_functions_chpwd" ""

__add_hook chpwd "__hook_some_function_2"
assert_equal "$__hook_functions_chpwd" ":__hook_some_function_2:"
