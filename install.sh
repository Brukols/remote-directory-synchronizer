#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo -ne "Illegal number of argument: Specify the directory where you want to install this tool\n"
    exit 1
fi

if [[ -d "$1" ]]; then
    echo "Install files..."
    cp .sync.env "$1"
    cp .syncignore "$1"
    cp synchronizer.sh "$1"
    echo "Done"
else
    echo "Please specify a directory"
fi
