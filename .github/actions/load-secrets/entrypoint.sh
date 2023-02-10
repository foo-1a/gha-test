#!/bin/sh -l

# credit to https://github.com/secrethub/actions/blob/master/env-export/entrypoint.sh

for s in $(cat secrets.list); do
    val=$(echo "$1" | jq -r ".$s")
    # Escape percent signs and add a mask per line (see https://github.com/actions/runner/issues/161)
    escaped_mask_value=$(echo "$val" | sed -e 's/%/%25/g')
    IFS=$'\n'
    for line in $escaped_mask_value; do
        echo "::add-mask::$line"
    done
    unset IFS

    random_heredoc_identifier=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n1)
    
    echo "$s<<${random_heredoc_identifier}" >> $GITHUB_ENV
    echo "$val" >> $GITHUB_ENV
    echo "${random_heredoc_identifier}" >> $GITHUB_ENV

done
