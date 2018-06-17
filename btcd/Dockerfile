FROM lightningnetwork/btcd-alpine

RUN apk add --no-cache bash
COPY ./start-btcd.sh .

ENTRYPOINT ["./start-btcd.sh"]
