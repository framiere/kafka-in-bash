#!/bin/bash

topic=demo

usage() {
    echo "echo \$RANDOM | kafka-console-consumer --topic $topic"
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

if [ ! -d ".topics/$topic" ] ; then
    echo "'$topic' topic does not exist, please use kafka-topics"
    exit 1
else
    nb_partitions=$(cat .topics/$topic/nb_partitions)
    partition=$((RANDOM%=nb_partitions))
    cat /dev/stdin >> .topics/$topic/partition-$partition.log
fi
