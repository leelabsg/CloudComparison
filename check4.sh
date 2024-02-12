#!/bin/bash

while IFS='/' read -r line || [[ -n "$line" ]]; do
    code=$(echo "$line" | sed 's/PRE //;s|/||g')
    echo "$code" >> out5.log
done < out4.log