#!/bin/bash

jq -Rr --slurp  '. | split("\n") | map(select(. != "")) | reduce .[] as $it ({}; . + { ($it) : "REPLACEME"})' secrets.list