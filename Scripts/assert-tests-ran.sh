#!/usr/bin/env bash
#
# assert-tests-ran.sh
#
# Guards against a silently-passing empty test suite. Both `swift test` and
# `xcodebuild test` exit 0 when the build succeeds but *zero* tests are
# discovered, which would let a broken test setup masquerade as green.
#
# Usage:
#   swift test 2>&1 | tee test.log
#   Scripts/assert-tests-ran.sh test.log
#
# Reads from the given file, or from stdin if no file is given.
# Exits non-zero when no tests were executed.

set -euo pipefail

input="${1:-/dev/stdin}"
log="$(cat "$input")"

# Both toolchains print lines like: "Executed 12 tests, with 0 failures ..."
# Sum every reported count so multiple suites/targets are tolerated.
total="$(printf '%s\n' "$log" \
    | grep -oE 'Executed [0-9]+ test' \
    | grep -oE '[0-9]+' \
    | awk '{ sum += $1 } END { print sum + 0 }')"

if [[ "$total" -eq 0 ]]; then
    echo "::error::No tests were executed — treating an empty test suite as a failure." >&2
    exit 1
fi

echo "assert-tests-ran: $total test(s) executed."
