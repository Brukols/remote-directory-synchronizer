#!/bin/bash

. .sync.env

# shellcheck disable=SC2095
inotifywait -r -m -e close_write --format '%w%f' ./ | while read MODFILE
do
    file="$(basename "${MODFILE}")"
    isIgnored=0

    while IFS= read -r line
    do
        if [[ "$file" == $line ]]; then
            echo "Skipping file $MODFILE"
            isIgnored=1
            break
        fi
    done < ".syncignore"
    if [ "$isIgnored" -eq 1 ]
    then
        continue
    fi
    newPath="${MODFILE:1}"
    directory="$(dirname "${MODFILE:1}")"
    echo "Copy $MODFILE to $REMOTE_DIRECTORY$newPath"
    ssh $USERNAME@$HOST mkdir -p $REMOTE_DIRECTORY$directory
    rsync -zv "$MODFILE" $USERNAME@$HOST:$REMOTE_DIRECTORY$newPath
done
