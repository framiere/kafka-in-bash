#!/bin/bash

mkdir -p .data/
mkdir -p .meta/

topic=""
partitions=4
action=list
retention=10

usage() {
    echo "kafka-topics --topic $topic --create --partitions 4\n
kafka-topics --list --describe
"
}

while [ "$1" != "" ]; do
    case $1 in
        --topic )               shift
                                topic=$1
                                ;;
        --partitions )          shift
                                partitions=$1
                                ;;
        --retention-in-bytes )  shift
                                retention=$1
                                ;;
        --create )               
                                action=create
                                ;;
        --describe )               
                                describe=true
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
        for topic in $(ls .meta); do 
            nb_partitions=$(cat .meta/$topic/nb_partitions)
            retention=$(cat .meta/$topic/retention)
            echo "$topic (partitions:$nb_partitions, retention:$retention)"
            if [ "$describe" = "true" ]; then
                for folder in $(find .data -d -name "$topic-*"); do
                    segments=$(ls $folder| wc -l | awk '{print $1}') 
                    size=$(ls $folder/*log | wc -c | awk '{print $1}') 
                    partition=$(basename $folder | cut -d - -f 2)
                    echo "    partition:$partition, segments:$segments, size:$size"
                done
            fi
        done
        ;;
    create)
        if [ "$topic" = "" ]; then
            echo "please specify a topic"
            exit 1
        fi
        mkdir -p .meta/$topic
        echo $partitions > .meta/$topic/nb_partitions
        echo $retention > .meta/$topic/retention
        seq 0 $partitions | xargs  -I % \
            sh -c "\
                    mkdir -p .data/$topic-% \
                    && touch .data/$topic-%/00000.log \
                    && echo 0 > .data/$topic-%/segment \
                    >> /dev/null"
        ;;
    delete)
        if [ "$topic" = "" ]; then
            echo "please specify a topic"
            exit 1
        fi
        rm -rf .data/$topic-*
        rm -rf .meta/$topic
        ;;
esac
