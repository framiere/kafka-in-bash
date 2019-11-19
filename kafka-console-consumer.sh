#!/bin/bash

mkdir -p .data/

topic=""
fromBeginning=0

usage() {
    echo "./kafka-console-consumer --topic $topic --from-beginning"
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

if [ "$topic" = "" ]; then
    echo "please specify a topic"
    exit 1
elif [ "$fromBeginning" = "1" ]; then
    tail -q -f -n +1 .data/$topic-*/*.log 2> /dev/null
else 
    tail -q -f -n 0 .data/$topic-*/*.log 2> /dev/null
fi 


