#!/bin/bash

echo "git commit -e -m \"$(date +"%m/%d/%Y %I:%M %p"):\""  | tee >(xclip -selection clipboard)
