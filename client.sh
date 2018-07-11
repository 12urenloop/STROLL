#!/bin/bash

SERVER="10.0.0.133"
PORT="2583"

# Use traditional netcat, to close when stdin closes
./scan.sh | nc.traditional -q 1 "$SERVER" "$PORT"
