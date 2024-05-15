#!/bin/bash

chr=22

# 스크립트 전체 실행 시작 시간 기록
echo "스크립트 시작 시간: $(date)"

function check_running_containers() {
    while : ; do
        local running=$(docker ps -q | wc -l) # 실행 중인 컨테이너의 수
        if [ "$running" -lt 10 ]; then
            break # 실행 중인 컨테이너의 수가 10 미만이면 반복 중단
        fi
        echo "현재 실행 중인 컨테이너가 10개 이상입니다. 잠시 기다리세요..."
        sleep 5m # 5분 대기
    done
}

for i in /media/leelabsg-storage1/KNIH_cloud/test_chr_intervals/chr${chr}/1/*
do
    a=${i%%.*}
    b=${a##*/}
    c=${b%%-*}

    # 각 파일 처리 시작 시간
    echo "처리 시작 시간 ($i): $(date)"

    check_running_containers
    docker run -dv /data/wgs_gvcf/:/data/wgs_gvcf/ broadinstitute/gatk:latest gatk --java-options "-Xms6000m -Xmx6000m" \
          GenotypeGVCFs \
          -R /data/wgs_gvcf/hs38DH.fa \
          -O /data/wgs_gvcf/test_GenotypeGVCFs/combined_${c}.chr${chr}.vcf.gz \
          -D /data/wgs_gvcf/hg38_bundle/Homo_sapiens_assembly38.dbsnp138.vcf \
          -G StandardAnnotation -G AS_StandardAnnotation \
          -V gendb:///data/wgs_gvcf/moon_dbimport/${c}/ \
          --max-genotype-count 2048 \
          --merge-input-intervals

    # 각 파일 처리 완료 시간
    echo "처리 완료 시간 ($i): $(date)"
done

# 스크립트 전체 실행 종료 시간 기록
echo "스크립트 종료 시간: $(date)"
