#!/bin/bash

mkdir -p .data/
mkdir -p .meta/
RANDOM=$$
topic=""

usage() {
    echo "echo \$RANDOM | ./kafka-console-producer --topic $topic"
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

if [ "$topic" = "" ]; then
    echo "please specify a topic"
    exit 1
elif [ ! -d ".meta/$topic" ] ; then
    echo "'$topic' topic does not exist, please use ./kafka-topics.sh"
    exit 1
else
    nb_partitions=$(cat .meta/$topic/nb_partitions)
    cat /dev/stdin | while read -r line ; do
        partition=$((RANDOM%=nb_partitions))
        echo "$line" | ./kafka-broker.sh --topic $topic --partition $partition
    done
fi
