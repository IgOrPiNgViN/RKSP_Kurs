#!/usr/bin/env bash
#   Use this script to test if a given TCP host/port are available
#   Usage:
#      wait-for-it.sh host:port [-s] [-t timeout] [-- command args]
#
#   host:port      Host and port to test
#   -s             Only execute subcommand if the test succeeds
#   -t timeout     Timeout in seconds, zero for no timeout
#   --             Pass arguments to the subcommand

set -e

TIMEOUT=15
STRICT=0
QUIET=0
HOST=""
PORT=""
CMD=("")

print_usage() {
    echo "Usage: $0 host:port [-s] [-t timeout] [-- command args]"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -s)
            STRICT=1
            shift
            ;;
        -q)
            QUIET=1
            shift
            ;;
        -t)
            TIMEOUT="$2"
            shift 2
            ;;
        --)
            shift
            CMD=("$@")
            break
            ;;
        *)
            if [[ -z "$HOST" ]]; then
                HOSTPORT="$1"
                HOST="${HOSTPORT%%:*}"
                PORT="${HOSTPORT##*:}"
                shift
            else
                print_usage
                exit 1
            fi
            ;;
    esac
done

if [[ -z "$HOST" || -z "$PORT" ]]; then
    print_usage
    exit 1
fi

wait_for() {
    for ((i=0; i<TIMEOUT; i++)); do
        if nc -z "$HOST" "$PORT"; then
            return 0
        fi
        sleep 1
    done
    return 1
}

if ! wait_for; then
    if [[ $QUIET -ne 1 ]]; then
        echo "Timeout occurred after waiting $TIMEOUT seconds for $HOST:$PORT"
    fi
    if [[ $STRICT -eq 1 ]]; then
        exit 1
    fi
else
    if [[ $QUIET -ne 1 ]]; then
        echo "$HOST:$PORT is available after waiting $TIMEOUT seconds"
    fi
fi

if [[ ${#CMD[@]} -gt 0 ]]; then
    exec "${CMD[@]}"
fi 