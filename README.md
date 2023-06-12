# docker-kafka-definitive-guide-v2

Tooling for spinning up Kafka setups in docker-compose that roughly follows
Chapter 2 of [Kafka: The Definitive Guide, 2nd Edition](https://learning.oreilly.com/library/view/kafka-the-definitive/9781492043072/).

## Quick Start
```
(terminal 1)
❯ make start-cluster

(terminal 2)
❯ bin/consumer localhost:29092 partition-1 test-group-1
[DEBUG] Consuming from topic partition-1
...
...

(terminal 3)
❯ bin/producer localhost:29092 partition-1 5 5
[DEBUG] Topic partition-1
[DEBUG] Batches 5 of size 5 with 1 second delay
...
...
```

## Usage

```
❯ make help
clean-%                        Clean target deployment stack for the given stem.
start-%                        Start target deployment stack for the given stem.
stop-%                         Stop target deployment stack for the given stem.
restart-broker-%               Restart broker for the given stem id.
start-broker-%                 Start v2 broker for the given stem id.
stop-broker-%                  Stop v2 broker for the given stem id.
pause-broker-%                 Pause v2 broker for the given stem id.
resume-broker-%                Resume v2 broker for the given stem id.
pause-zk                       Pause zookeeper.
resume-zk                      Resume zookeeper.
help                           Show help/usage.
```

## Stacks

There is one available stacks to run:

* `cluster` - This runs a 3 broker Kafka cluster with 1 Zookeeper node. Config (here)[deploy/docker/cluster].

### Running a stack

Simply run `make start`, `make stop`, and `make clean` with the stack version of your choice.

```
❯ make start-cluster
❯ make stop-cluster
❯ make clean-cluster
```

### Topic Creation

The stacks have a helper script and CSV file (found [here](deploy/docker/partials/kafka_3/rootfs/kafka-init.d)) that creates topics for you.

By default, the following are created:


| Name | Partitions | Replication Factor |
|------|------------|--------------------|
| partition-1 | 1 | 1 |
| partition-3 | 3| 1 |

### Altering Configuration

Let's say we want to alter a topic configuration outlined in the book. Let's open a shell and run some commands.

```
# Open a shell.
❯ make shell-broker-1


# List all topics.
[appuser@3dd3d054cbc0 ~]$ kafka-topics --bootstrap-server kafka_1:9091 --list
__consumer_offsets
partition-1
partition-3

# Show configuration for topic partition-1
[appuser@3dd3d054cbc0 ~]$ kafka-topics --bootstrap-server kafka_1:9091 --describe --topic partition-1
Topic: partition-1	TopicId: fTavOk4dTJeq6LxffXPGEg	PartitionCount: 1	ReplicationFactor: 1	Configs: cleanup.policy=delete
	Topic: partition-1	Partition: 0	Leader: 2	Replicas: 2	Isr: 2

# Alter configuration for topic partition-1 (set retention bytes to 1MB).
[appuser@3dd3d054cbc0 ~]$ kafka-configs --bootstrap-server kafka_1:9091 --alter --entity-type topics --entity-name partition-1 --add-config retention.bytes=1048576
Completed updating config for topic partition-1.

# Show configuration to see change.
[appuser@3dd3d054cbc0 ~]$ kafka-topics --bootstrap-server kafka_1:9091 --describe --topic partition-1
Topic: partition-1	TopicId: fTavOk4dTJeq6LxffXPGEg	PartitionCount: 1	ReplicationFactor: 1	Configs: cleanup.policy=delete,retention.bytes=1048576
	Topic: partition-1	Partition: 0	Leader: 2	Replicas: 2	Isr: 2
```

### Configuration

In Chapter 2 of the book, it will discuss many of the configuration values available for configuring Kafka. These don't
match our setup here _identically_ because we configure the brokers via environment variables instead of configuration files.

Environment variables are all uppercase and prefixed with `KAFKA_`. That's it. For example:

`KAFKA_BROKER_ID` maps to `broker.id`.
