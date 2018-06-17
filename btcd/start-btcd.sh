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
  --txindex \
  --datadir=/data \
  "--rpcuser=$RPCUSER" \
  "--rpcpass=$RPCPASS" \
  --rpclisten=0.0.0.0 \
  --rpccert=/rpc/rpc.cert \
  --rpckey=/rpc/rpc.key \
)

PARAMS="$PARAMS $@"

exec btcd $PARAMS
