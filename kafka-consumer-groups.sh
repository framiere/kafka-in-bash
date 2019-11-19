#!/bin/bash

mkdir -p .data/
mkdir -p .meta/

topic=""

usage() {
    echo "./kafka-consumer-group.sh --topic demo"
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
    lsof | grep "$PWD/.data/$topic-.*/.*log" | while read -r line ; do
        user=$(echo $line | awk '{print $3}')
        offset=$(echo $line | awk '{print $7}')
        file=$(echo $line | awk '{print $9}')
        topicPartition=$(basename $(dirname $file))
        partition=$(echo $topicPartition | cut -d - -f 2 | cut -d . -f 1)
        echo user:$user topic:$topic partition:$partition offset:$offset
    done
}

if [ "$topic" != "" ]; then
    describe $topic
else 
    for topic in $(ls $PWD/.meta); do
        describe $topic
    done
fi