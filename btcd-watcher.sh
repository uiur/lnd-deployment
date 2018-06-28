#!/bin/bash -xe

POST_INIT_SYNC_DELAY=60
POLL_DELAY=60
STALL_THRESHOLD=5
COMPOSE_INTERACTIVE_NO_CLI=1
BTCCTL='docker-compose exec -T btcd ./start-btcctl.sh'

stalls=0
echo "Starting watcher..."
while true; do
    start=`$BTCCTL getinfo | jq -r .blocks`
    sleep $POLL_DELAY
    end=`$BTCCTL getinfo | jq -r .blocks`
    echo "Processed $((end - start)) blocks in the last $POLL_DELAY seconds"
    if [[ "$start" == "$end" ]]; then
        if (( stalls > STALL_THRESHOLD )); then
            echo "Too many stalls detected. Restarting btcd..."
            docker-compose restart btcd
            stalls=0
        else
            syncnode=`eval "$BTCCTL getpeerinfo | jq -r '.[] | select(.syncnode == true) | .addr' | cut -f1 -d:"`
            if [ -z "$syncnode" ]; then
                echo "Stall detected, but no syncnode found. Restarting btcd..."
                docker-compose restart btcd
                stalls=0
            else
                echo "Stall detected! Evicting potentially bad node $syncnode"
                eval "$BTCCTL node disconnect $syncnode"
                stalls=$(( stalls + 1 ))
            fi
        fi
    fi
done