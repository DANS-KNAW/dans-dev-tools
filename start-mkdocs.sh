#!/usr/bin/env bash

if [ -z "$VIRTUAL_ENV" ]; then
  echo "First start the virtual environment with start-virtual-env.sh and then activate it"
  exit 1
fi

echo -n "Upgrading pip3..."
./venv/bin/python3 -m pip install --upgrade pip
echo "OK"

echo "Installing dependencies for doc site..."
pip3 install -r .github/workflows/mkdocs/requirements.txt
echo "...OK"

./venv/bin/mkdocs serve



