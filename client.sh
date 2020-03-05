#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "[Error] Illegal number of parameters"
    echo "[Error] Usage: $0 [server] [port]"
    echo
    echo "The telraam beacon listener listens by default on port 4564"
    exit 1
fi

SERVER="$1"
PORT="$2"

echo "Server $1 on port $2"
# Use traditional netcat, to close when stdin closes
./scan.sh | nc -q 1 "$SERVER" "$PORT"
