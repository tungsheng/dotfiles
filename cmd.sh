#!/bin/bash

error() {
    echo "could not execute cmd... Exit!"
}

dbget() {
    source ./scripts/util/db-get.sh
}

if [ $# -gt 0 ]; then
    case $1 in
        db-get | dbget )        dbget
                                exit
                                ;;
        * )                     error
                                exit 1
    esac
else
    echo "Need to pass args..."
fi
