#!/bin/bash

topic=demo
partitions=1
list=1
create=0

usage() {
    echo "kafka-topics --topic $topic --create --partitions 4"
}

while [ "$1" != "" ]; do
    case $1 in
        --topic )               shift
                                topic=$1
                                ;;
        --partitions )          shift
                                partitions=$1
                                ;;
        --create )               
                                create=1
                                ;;
        --list )               
                                list=1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [ "$list" = "1" ]; then
    for topic in $(ls .topics); do 
        nb_partitions=$(cat .topics/$topic/nb_partitions)
        echo $topic - $nb_partitions partitions
    done
else 
    mkdir -p .topics/$topic
    echo $partitions > .topics/$topic/nb_partitions
fi