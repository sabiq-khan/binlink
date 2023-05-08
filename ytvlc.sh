#!/bin/bash

#yt-dlp
vidFile=$(yt-dlp $1 -P ~/Videos/yt-dlp | grep "[download] Destination: " | sed "s/[download] Destination: //g") 
#echo "find cmd output: $(find ~/Videos/yt-dlp -type f -name "*.webm")"

#VLC
echo $vidFile

#Clear yt-dlp video cache
rm ~/Videos/yt-dlp/*.webm*

