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

mkdir -p .topics/$topic
cat /dev/stdin >> .topics/$topic/partition-$((RANDOM%=10)).log
