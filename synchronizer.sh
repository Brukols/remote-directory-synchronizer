#!/bin/bash

. .sync.env

ftp=0
pwd=`pwd`

while test $# -gt 0; do
    case "$1" in
        -f)
            ftp=1
            shift
        ;;
        *)
            break
        ;;
    esac
done

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
    name="$(basename "${MODFILE:1}")"

    echo "Copy $MODFILE to $REMOTE_DIRECTORY$newPath"
    if [ "$ftp" -eq 0 ]
    then
        ssh $USERNAME@$HOST mkdir -p $REMOTE_DIRECTORY$directory
        rsync -zv "$MODFILE" $USERNAME@$HOST:$REMOTE_DIRECTORY$newPath
    else
        # shellcheck disable=SC2006
        echo -ne "user $USERNAME $PASSWORD\nmkdir $REMOTE_DIRECTORY$directory\ncd $REMOTE_DIRECTORY$directory\nput $pwd$newPath $name\nls\n" | ftp -n -v $HOST
    fi
done
