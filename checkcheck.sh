#!/bin/bash

# out3.log 파일을 읽어서 원하는 파일 이름만 추출하여 out4.log에 저장
grep "cannot" out1.log | awk -F"'" '{print $2}' | cut -d '.' -f 1 > out2.log
