#!/bin/bash

TESTS_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$TESTS_DIR")"
BINARY="$PROJECT_DIR/calculateExe"

PASS=0
FAIL=0

echo "--- Running calculate tests ---"

(cd "$TESTS_DIR" && "$BINARY")

for FILE in balances_out.dat overdraft_out.dat reject_out.dat; do
    EXPECTED="$TESTS_DIR/exp_$FILE"
    ACTUAL="$TESTS_DIR/$FILE"

    if diff -q "$EXPECTED" "$ACTUAL" > /dev/null 2>&1; then
        echo "  PASS: $FILE"
        ((PASS++))
    else
        echo "  FAIL: $FILE"
        diff "$EXPECTED" "$ACTUAL"
        ((FAIL++))
    fi
done

# Clean up temp files 
rm -f "$TESTS_DIR/balances_out.dat" \
      "$TESTS_DIR/overdraft_out.dat" \
      "$TESTS_DIR/reject_out.dat"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ $FAIL -eq 0 ] && exit 0 || exit 1


# for linebreak fix: sed -i 's/\r$//' test_calculate.sh