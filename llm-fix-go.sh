#!/bin/sh

go build 2>&1 \
  | cat *.go - \
  | llm -s '
  below you find a golang program and the 
  "go build" output. 
  How can I fix the error message?
  '

