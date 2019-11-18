#!/bin/bash
mkdir -p .topics/

topic=""

usage() {
    echo "kafka-consumer-group --topic demo"
}

while [ "$1" != "" ]; do
    case $1 in
        --topic )               shift
                                topic=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

describe() {
    topic=$1
    echo describe $topic
    echo lsof | grep $PWD/.topics/$topic
    lsof | grep $PWD/.topics/$topic/partition | while read -r line ; do
        user=$(echo $line | awk '{print $3}')
        offset=$(echo $line | awk '{print $7}')
        file=$(echo $line | awk '{print $9}')
        basename=$(basename $file)
        partition=$(echo $basename | cut -d - -f 2 | cut -d . -f 1)
        echo $topic - user:$user partition:$partition offset:$offset
    done
}

if [ "$topic" != "" ]; then
    describe $topic
else 
    for topic in $(ls $PWD/.topics); do
        describe $topic
    done
fi