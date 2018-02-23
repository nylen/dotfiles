#!/bin/bash

cd "$(dirname "$0")"
. ../.bashrc_nylen_dotfiles

failures=0
output="/tmp/nylen-dotfiles-test.$$.sh"

for t in ./test-*.sh; do
	echo -n "$t ... "
	if bash "$t" > "$output" 2>&1; then
		echo -ne $(__terminal_color '0;32m') # green
		echo 'OK'
		echo -ne $(__terminal_color '0m') # reset
	else
		echo -ne $(__terminal_color '1;31m') # bold red
		echo 'FAILED'
		echo -ne $(__terminal_color '0m') # reset
		echo
		cat "$output"
		failures=$(($failures + 1))
		echo
	fi
done

rm -f "$output"

if [ "$failures" -gt 0 ]; then
	echo -ne $(__terminal_color '1;31m') # bold red
	echo "Test failures: $failures"
	echo -ne $(__terminal_color '0m') # reset
else
	echo -ne $(__terminal_color '0;32m') # green
	echo "All tests OK"
	echo -ne $(__terminal_color '0m') # reset
fi

exit $failures
