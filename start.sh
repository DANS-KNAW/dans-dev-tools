#!/usr/bin/env bash

for a in "$@"
do
  ARGS="$ARGS'$a' "
done

set -x
mvn exec:java -Dexec.args="$ARGS"
