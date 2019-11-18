# kafka-in-bash

Let's try to redo kafka in bash 

```
./kafka-topics.sh --list
./kafka-topics.sh --topic demo --partitions 10 --create
./kafka-topics.sh --list
seq 10 | ./kafka-console-producer.sh --topic demo
./kafka-console-consumer.sh --topic demo
./kafka-console-consumer.sh --topic demo --from-beginning
./kafka-topics.sh --topic demo --delete
./kafka-topics.sh --list
```

[![asciicast](https://asciinema.org/a/282262.svg)](https://asciinema.org/a/282262)