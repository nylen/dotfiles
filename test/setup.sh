#!/bin/bash

shopt -s expand_aliases
. ../.bashrc_nylen_dotfiles

assert_equal_impl() {
	line="$1"
	actual="$2"
	expected="$3"
	if [ x"$actual" != x"$expected" ]; then
		# Do cleanup
		# Some tests ($PATH manipulation) break commands until this is done
		do_cleanup
		unset -f test_cleanup

		# Print the line before the failing assertion
		echo -ne $(__terminal_color '0;34m') # blue
		echo -n "$(($line - 1)):"
		echo -ne $(__terminal_color '0m') # reset
		cat "$(basename "$0")" | head -n "$(($line - 1))" | tail -n 1

		# Print the failing assertion line
		echo -ne $(__terminal_color '0;34m') # blue
		echo -n "$line:"
		echo -ne $(__terminal_color '0m') # reset
		cat "$(basename "$0")" | head -n "$line" | tail -n 1

		# Print expected/actual values
		echo -ne $(__terminal_color '0;32m') # green
		echo "Expected '$expected'"
		echo -ne $(__terminal_color '1;31m') # bold red
		echo "Actual   '$actual'"
		echo -ne $(__terminal_color '0m') # reset

		exit 1
	fi
}
alias assert_equal='assert_equal_impl $LINENO'

do_cleanup() {
	if [ "$(type -t test_cleanup)" = function ]; then
		test_cleanup
	fi
}

trap do_cleanup EXIT
