#!/bin/bash

touch new.txt
find . -newermt "$(date -d '-1 sec' +'%Y-%m-%d %H:%M:%S')" -name "*.txt"

