#!/usr/bin/env bash
#
# Entrypoint for "kafka-init".
#
# This entrypoint will run all init scripts within the /kafka-init.d
# directory that allows uses to customize their Kafka cluster, e.g. creating topics.

wait_for_kafka_cluster() {
  local -r host="${1}"
  local -r port="${2}"

  until nc -z "${host}" "${port}" > /dev/null; do
    echo "Waiting for cluster at ${host}:${port}"
    sleep 5
  done;
}

process_init_files() {
  for init_file in "$@"; do
    case "${init_file}" in
      *.sh)
        echo "Executing init file ${init_file}"
        "${init_file}"
        ;;
      *)
        echo "Ignoring file ${init_file}"
        ;;
    esac
  done
}

main() {
  wait_for_kafka_cluster "${BOOTSTRAP_SERVER}" "${BOOTSTRAP_SERVER_PORT}"
  process_init_files /kafka-init.d/*
}

main "$@"
