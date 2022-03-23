#!/bin/sh

port=$1
[ "$port" ] || { echo "usage: $0 port"; exit 1; }

ssh -L $port:127.0.0.1:$port -fN fxnn.de

