#!/bin/bash

chr=22
function check_running_containers() {
    while : ; do
        local running=$(docker ps -q | wc -l) # 실행 중인 컨테이너의 수
        if [ "$running" -lt 10 ]; then
            break # 실행 중인 컨테이너의 수가 100 미만이면 반복 중단
        fi
        echo "현재 실행 중인 컨테이너가 100개 이상입니다. 잠시 기다리세요..."
        sleep 5m # 5분 대기
    done
}
# ls /data/wgs_gvcf/test_noACs/chr${chr}/*.gz > /data/wgs_gvcf/noAC_input.list
for i in /media/leelabsg-storage1/KNIH_cloud/test_chr_intervals/chr${chr}/1/*
do
check_running_containers
a=${i%%.*}
b=${a##*/}
c=${b%%-*}
docker run -dv /data/wgs_gvcf/:/data/wgs_gvcf/ -v /media/leelabsg-storage1/KNIH_cloud/:/media/leelabsg-storage1/KNIH_cloud/ broadinstitute/gatk:latest gatk --java-options "-Xms8000m -Xmx25000m" \
      GenomicsDBImport \
      --genomicsdb-workspace-path /data/wgs_gvcf/moon_dbimport/$c/ \
      --batch-size 20 \
      --variant /data/wgs_gvcf/noAC_input.list \
      -L  $i \
      --reader-threads 5 \
      --merge-input-intervals \
      --consolidate
done
