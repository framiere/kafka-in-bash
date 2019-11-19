#!/bin/bash

mkdir -p .topics/

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


cat /dev/stdin | while read -r line ; do
    echo $line >> .topics/$topic/partition-$partition.log
done