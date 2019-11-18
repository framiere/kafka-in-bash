#!/bin/bash

topic=demo
fromBeginning=0

usage() {
    echo " kafka-console-consumer --topic $topic --from-beginning"
}

while [ "$1" != "" ]; do
    case $1 in
        --topic )               shift
                                topic=$1
                                ;;
        --from-beginning )       
                                fromBeginning=1
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

if [ "$fromBeginning" = "1" ]; then
    tail -q -f -n +1 .topics/$topic/partition-*.log 2> /dev/null
else 
    tail -q -f -n 0 .topics/$topic/partition-*.log 2> /dev/null
fi 


