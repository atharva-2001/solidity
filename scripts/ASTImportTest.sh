#!/usr/bin/env bash

# Bash script to test the ast-import option of the compiler by
# first exporting a .sol file to JSON, then loading it into the compiler
# and exporting it again. The second JSON should be identical to the first

set -eo pipefail
READLINK=readlink
if [[ "$OSTYPE" == "darwin"* ]]; then
    READLINK=greadlink
fi
REPO_ROOT=$(${READLINK} -f "$(dirname "$0")"/..)
# shellcheck source=scripts/common_import.sh
source "${REPO_ROOT}/scripts/common_import.sh"

SYNTAXTESTS_DIR="${REPO_ROOT}/test/libsolidity/syntaxTests"
ASTJSONTESTS_DIR="${REPO_ROOT}/test/libsolidity/ASTJSON"
NSOURCES="$(find "$SYNTAXTESTS_DIR" -type f | wc -l)"

init_import_tests

# function tests whether exporting and importing again leaves the JSON ast unchanged
# Results are recorded by adding to FAILED or UNCOMPILABLE.
# Also, in case of a mismatch a diff and the respective ASTs are printed
# Expected parameters:
# $1 name of the file to be exported and imported
# $2 any files needed to do so that might be in parent directories
function testImportExportEquivalence {
    local nth_input_file="$1"
    IFS=" " read -r -a all_input_files <<< "$2"

    if $SOLC "$nth_input_file" "${all_input_files[@]}" > /dev/null 2>&1
    then
        # save exported json as expected result (silently)
        $SOLC --combined-json ast,compact-format --pretty-json "$nth_input_file" "${all_input_files[@]}" > expected.json 2> /dev/null
        # import it, and export it again as obtained result (silently)
        if ! $SOLC --import-ast --combined-json ast,compact-format --pretty-json expected.json > obtained.json 2> /dev/null
        then
            # For investigating, use exit 1 here so the script stops at the
            # first failing test
            # exit 1
            FAILED=$((FAILED + 1))
            return 1
        fi
        DIFF="$(diff expected.json obtained.json)"
        if [ "$DIFF" != "" ]
        then
            if [ "$DIFFVIEW" == "" ]
            then
                echo -e "ERROR: JSONS differ for $1: \n $DIFF \n"
                echo "Expected:"
                cat ./expected.json
                echo "Obtained:"
                cat ./obtained.json
            else
                # Use user supplied diff view binary
                $DIFFVIEW expected.json obtained.json
            fi
            FAILED=$((FAILED + 1))
            return 2
        fi
        TESTED=$((TESTED + 1))
        rm expected.json obtained.json
    else
        # echo "contract $solfile could not be compiled "
        UNCOMPILABLE=$((UNCOMPILABLE + 1))
    fi
    # return 0
}
echo "Looking at $NSOURCES .sol files..."

# for solfile in $(find $DEV_DIR -name *.sol)
# boost_filesystem_bug specifically tests a local fix for a boost::filesystem
# bug. Since the test involves a malformed path, there is no point in running
# AST tests on it. See https://github.com/boostorg/filesystem/issues/176
TEST_FILES=$(find "$SYNTAXTESTS_DIR" "$ASTJSONTESTS_DIR" -name "*.sol" -and -not -name "boost_filesystem_bug.sol")
run_import_tests "$TEST_FILES" "$SPLITSOURCES" "$NSOURCES" "$PWD"
