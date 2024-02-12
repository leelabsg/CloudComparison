#!/bin/bash

# 파일에서 각 라인을 읽어옴
while IFS= read -r line; do
    # 각 라인을 ${line}에 넣고 명령어 실행하고 결과를 out11.log에 추가
    aws s3 cp s3://choi-lab-koges/WGS/"${line}" . --recursive --request-payer requester 
done < out10_1000.log
