#!/bin/bash

mkdir -p .data/
mkdir -p .meta/
RANDOM=$$

usage() {
    echo "echo 'something' | ./kafka-broker.sh --topic demo --partition 1"
}

while [ "$1" != "" ]; do
    case $1 in
        --topic )               shift
                                topic=$1
                                ;;
        --partition )           shift
                                partition=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     line=$1
                                ;;
    esac
    shift
done

to_segment() {
    topic=$1
    partition=$2
    segment=$3
}

retention=$(cat .meta/$topic/retention)
segment=$(cat .data/$topic-$partition/segment)
cat /dev/stdin | while read -r line ; do
    segment_name=$(printf "%05d\n" $segment)
    size=$(wc -c < .data/$topic-$partition/$segment_name.log)
    if [ "$size" -gt "$retention" ]; then
        segment=$((segment + 1))
        echo $segment > .data/$topic-$partition/segment
    fi
    segment_name=$(printf "%05d\n" $segment)
    echo $line >> .data/$topic-$partition/$segment_name.log
done