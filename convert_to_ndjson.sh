#!/usr/bin/env bash
# brew install jq

if (($# < 2)); then
    echo "Dependencies: jq"
    echo "Usage: $0 <json file> <ndjson filename>"
elif (($# > 2)); then
    echo "Dependencies: jq"
    echo "Usage: $0 <json file> <ndjson filename>"
else
    jq -c '.[]' $1 > $2
fi
