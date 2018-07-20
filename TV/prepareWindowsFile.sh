#!/usr/bin/env bash

if [ "$#" -eq 0 ]; then
    echo "Type in Windows file path you want to convert to Linux."
    exit 1
else
    tr -d '\15\32' < $1 > unixfile
    tr -cd '\11\12\15\40-\176' < unixfile > "Final${1}"

    rm unixfile
fi

