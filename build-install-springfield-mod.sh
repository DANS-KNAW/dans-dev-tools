#!/usr/bin/env bash

if (( $# < 2 )); then
    echo "Installs springfield module into local Maven cache"
    echo
    echo "Usage: $(basename $0) <artifact> <version>"
    echo "Example: $(basename $0) war/momar.war 1.0.0"
    exit 1
fi

ARTIFACT=$1
VERSION=$2
BASENAME=$(basename $ARTIFACT)
MODULE=$(echo $BASENAME | cut -d. -f1)
EXT=$(echo $BASENAME | cut -d. -f2)
SPRINGFIELD_PACKAGE=springfield2

mvn install:install-file -Dfile=$ARTIFACT -DartifactId=$MODULE -Dpackaging=$EXT -DgroupId=$SPRINGFIELD_PACKAGE -Dversion=$VERSION
