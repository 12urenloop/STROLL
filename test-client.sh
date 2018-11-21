#!/bin/bash

SERVER="$1"
PORT="$2"

echo "Server $1 on port $2"
# Use traditional netcat, to close when stdin closes
./test.sh | nc "$SERVER" "$PORT"
