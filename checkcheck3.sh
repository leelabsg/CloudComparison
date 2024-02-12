#!/bin/bash

# out8.log 파일에 있는 항목들을 저장할 배열 선언
# excluded=()

# # out8.log 파일을 읽어서 excluded 배열에 저장
# while IFS= read -r line; do
#     excluded+=("$line")
# done < "out2.log"

# # out5.log 파일을 읽어서 out8.log에 있는 항목들을 제외한 항목들을 out9.log에 저장
# while IFS= read -r line; do
#     # line이 excluded 배열에 없으면 out9.log에 저장
#     if [[ ! " ${excluded[@]} " =~ " ${line} " ]]; then
#         echo "$line" >> out3.log
#     fi
# done < "out.log"
excluded=()

# out8.log 파일을 읽어서 excluded 배열에 저장
while IFS= read -r line; do
    excluded+=("$line")
done < "out3.log"

# out5.log 파일을 읽어서 out8.log에 있는 항목들을 제외한 항목들을 out9.log에 저장
while IFS= read -r line; do
    # line이 excluded 배열에 없으면 out9.log에 저장
    if [[ ! " ${excluded[@]} " =~ " ${line} " ]]; then
        echo "$line" >> out6.log
    fi
done < "out5.log"