#!/bin/bash

# inspired by: https://github.com/microsoft/codeql-container/blob/main/scripts/unix/run_ql_suite.sh

codeql version
codeql resolve queries

CODEQL_LANGUAGE="javascript"
CODEQL_SUITE="javascript-code-scanning.qls"
# CODEQL_SUITE="javascript-security-and-quality.qls"
# CODEQL_SUITE="javascript-security-extended.qls"

echo
echo "CodeQL scan"
echo "Docs: https://codeql.github.com/docs/"
echo "using container: mcr.microsoft.com/cstsectools/codeql-container:latest"
echo

rm -r /opt/results/*
if [ $? -eq 0 ]
then
    echo
    echo "successfully wiped out previous run results, ready to start."
    echo
else
    echo
    echo "Failed to wipe out previos run results.  Please delete the codeql-results folder and try again."
    exit 1
fi

codeql database create --language=$CODEQL_LANGUAGE /opt/results/source_db -s /opt/src
if [ $? -eq 0 ]
then
    echo
    echo "Created the database"
    echo
else
    echo
    echo "Failed to create the database"
    exit 1
fi

codeql database upgrade /opt/results/source_db
if [ $? -eq 0 ]
then
    echo
    echo "Upgraded the database"
    echo
else
    echo
    echo "Failed to upgrade the database"
    exit 2
fi

codeql database analyze /opt/results/source_db --format=sarifv2.1.0 --output=/opt/results/issues.sarif $CODEQL_SUITE
if [ $? -eq 0 ]
then
    echo
    echo "Query execution successful"
    echo
    echo "The results are saved at /codeql-results/issues.sarif"
    echo "sarif viewing info: https://help.semmle.com/ql-for-vs/Content/WebHelp/view-results.html"
    echo "sarif VSCode extension: https://marketplace.visualstudio.com/items?itemName=MS-SarifVSCode.sarif-viewer"
else
    echo
    echo "Query execution failed"
    exit 3
fi
