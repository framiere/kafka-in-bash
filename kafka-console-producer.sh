#!/bin/bash

mkdir -p .topics/

topic=""

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

if [ "$topic" = "" ]; then
    echo "please specify a topic"
    exit 1
elif [ ! -d ".topics/$topic" ] ; then
    echo "'$topic' topic does not exist, please use kafka-topics"
    exit 1
else
    nb_partitions=$(cat .topics/$topic/nb_partitions)
    cat /dev/stdin | while read -r line ; do
        partition=$((RANDOM%=nb_partitions))
        echo $line >> .topics/$topic/partition-$partition.log
    done
fi
