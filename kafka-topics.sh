#!/bin/bash

mkdir -p .topics/

topic=""
partitions=4
action=list

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
                                action=create
                                ;;
        --delete )               
                                action=delete
                                ;;
        --list )               
                                action=list
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

case $action in
    list)
        for topic in $(ls .topics); do 
            nb_partitions=$(cat .topics/$topic/nb_partitions)
            echo $topic - $nb_partitions partitions
        done
        ;;
    create)
        if [ "$topic" = "" ]; then
            echo "please specify a topic"
            exit 1
        fi
        mkdir -p .topics/$topic
        echo $partitions > .topics/$topic/nb_partitions
        seq $partitions | xargs  -I % sh -c "touch .topics/$topic/partition-%.log"
        ;;
    delete)
        if [ "$topic" = "" ]; then
            echo "please specify a topic"
            exit 1
        fi
        rm -rf .topics/$topic
        ;;
esac
