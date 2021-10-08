#!/usr/bin/env bash

ETCDIR=etc
DATADIR=data
INIT_DEBUG_ENV_SCRIPT=./debug-init-env.sh

echo -n "(Re-)creating $ETCDIR..."
rm -fr $ETCDIR
cp -r src/test/resources/debug-etc $ETCDIR
echo "OK"

if [ -e $DATADIR ]; then
    DATADIR_BACKUP=$DATADIR-$(date  +"%Y-%m-%d@%H:%M:%S")
    echo -n "Backing up existing data directory to $DATADIR_BACKUP..."
    mv $DATADIR $DATADIR_BACKUP
    echo "OK"
fi

mkdir $DATADIR

if [ -f $INIT_DEBUG_ENV_SCRIPT ]; then
    echo "START: project specific initialization in $INIT_DEBUG_ENV_SCRIPT..."
    source $INIT_DEBUG_ENV_SCRIPT
    echo "DONE: project specific initialization."
    echo
fi

echo "The debug environment has been reinitialized."

echo "Config directory at: $ETCDIR"
echo "Data and logging directory at: $DATADIR"
