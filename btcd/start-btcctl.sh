#!/usr/bin/env bash

set -e

error() {
    echo "$1" > /dev/stderr
    exit 0
}

return() {
    echo "$1"
}

PARAMS=$(echo \
  "--rpcuser=$RPCUSER" \
  "--rpcpass=$RPCPASS" \
  --rpccert=/rpc/rpc.cert
)

PARAMS="$PARAMS $@"

exec btcctl $PARAMS
