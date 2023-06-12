#!/usr/bin/env bash
#
# Create all topics defined in topics.csv

main() {
  {
    read -r
    while IFS=, read -r topic partitions replication_factor; do
      echo "Creating kafka topic (if not already exists): ${topic}"
      kafka-topics \
        --create \
        --if-not-exists \
        --topic "${topic}" \
        --partitions "${partitions}" \
        --replication-factor "${replication_factor}" \
        --bootstrap-server "${BOOTSTRAP_SERVER}:${BOOTSTRAP_SERVER_PORT}"
    done
  } < "/kafka-init.d/topics.csv"
}

main "$@"
