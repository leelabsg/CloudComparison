#! /bin/bash
set -e
exec > >(tee /var/log/startup-script.log) 2>&1

sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb

sudo mkdir -p /mnt/disks/data1/
sudo mount /dev/sdb /mnt/disks/data1/

sudo mkdir -p /mnt/disks/data1/SAIGE/SAIGE_Step1/
sudo mkdir -p /mnt/disks/data1/SAIGE/SAIGE_Step2/output

gsutil cp gs://leelabsg-cloud-test/UKBB/SAIGE_Step1/UKB_step1.bim /mnt/disks/data1/SAIGE/SAIGE_Step1/
gsutil cp gs://leelabsg-cloud-test/UKBB/SAIGE_Step1/UKB_step1.bed /mnt/disks/data1/SAIGE/SAIGE_Step1/
gsutil cp gs://leelabsg-cloud-test/UKBB/SAIGE_Step1/UKB_step1.fam /mnt/disks/data1/SAIGE/SAIGE_Step1/

sudo apt-get update
sudo apt-get install -y docker.io

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

docker pull wzhou88/saige:1.3.0

docker run -w /mnt/disks/data1/SAIGE/SAIGE_Step1 -v /mnt/disks/data1/SAIGE/SAIGE_Step1/:/mnt/disks/data1/SAIGE/SAIGE_Step1/ wzhou88/saige:1.3.0 createSparseGRM.R \
        --plinkFile=/mnt/disks/data1/SAIGE/SAIGE_Step1/UKB_step1       \
        --nThreads=4   \
        --outputPrefix=/mnt/disks/data1/SAIGE/SAIGE_Step1/sparseGRM \
        --numRandomMarkerforSparseKin=2000 \
        --relatednessCutoff=0.125

gsutil cp gs://leelabsg-cloud-test/UKBB/SAIGE_Step1/{pheno_file}.txt /mnt/disks/data1/SAIGE/SAIGE_Step1/

docker run -w /mnt/disks/data1/SAIGE/SAIGE_Step1 -v /mnt/disks/data1/SAIGE/SAIGE_Step1/:/mnt/disks/data1/SAIGE/SAIGE_Step1/ wzhou88/saige:1.3.0 step1_fitNULLGLMM.R     \
        --useSparseGRMtoFitNULL=TRUE    \
        --sparseGRMFile=/mnt/disks/data1/SAIGE/SAIGE_Step1/sparseGRM_relatednessCutoff_0.125_2000_randomMarkersUsed.sparseGRM.mtx       \
        --sparseGRMSampleIDFile=/mnt/disks/data1/SAIGE/SAIGE_Step1/sparseGRM_relatednessCutoff_0.125_2000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt \
        --plinkFile=/mnt/disks/data1/SAIGE/SAIGE_Step1/UKB_step1        \
        --phenoFile=/mnt/disks/data1/SAIGE/SAIGE_Step1/{pheno_file}_pheno.txt    \
        --phenoCol=HDL     \
        --covarColList=Sex,Age,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10   \
        --sampleIDColinphenoFile=eid     \
        --traitType=quantitative        \
        --invNormalize=TRUE     \
        --outputPrefix=./output/{pheno_file}_Step1        \
        --nThreads=4    \
        --LOCO=TRUE     \
        --FemaleCode=2  \
        --MaleCode=1    \
        --IsOverwriteVarianceRatioFile=TRUE

sudo gsutil cp gs://leelabsg-cloud-test/UKBB/SAIGE_Step2/ukb45227_imp_chr1_v3_s487296.sample /mnt/disks/data1/SAIGE/SAIGE_Step2/

for ((chr=1; chr<=22; chr++))
do
        gsutil cp gs://leelabsg-cloud-test/UKBB/SAIGE_Step2/ukb_imp_chr${chr}_v3.bgen.bgi /mnt/disks/data1/SAIGE/SAIGE_Step2/
        gsutil cp gs://leelabsg-cloud-test/UKBB/SAIGE_Step2/ukb_imp_chr${chr}_v3.bgen /mnt/disks/data1/SAIGE/SAIGE_Step2/

        docker run -w /mnt/disks/data1/SAIGE/ -v /mnt/disks/data1/SAIGE/:/mnt/disks/data1/SAIGE/ wzhou88/saige:1.3.0 step2_SPAtests.R   \
                --bgenFile=/mnt/disks/data1/SAIGE/SAIGE_Step2/ukb_imp_chr${chr}_v3.bgen \
                --bgenFileIndex=/mnt/disks/data1/SAIGE/SAIGE_Step2/ukb_imp_chr${chr}_v3.bgen.bgi        \
                --minMAF=0.0001 \
                --minMAC=10     \
                "--chrom="$(print "%02d" $chr)  \
                --GMMATmodelFile=/mnt/disks/data1/SAIGE/SAIGE_Step1/output/{pheno_file}_Step1.rda        \
                --sampleFile=/mnt/disks/data1/SAIGE/SAIGE_Step2/ukb45227_imp_chr1_v3_s487296.sample     \
                --varianceRatioFile=/mnt/disks/data1/SAIGE/SAIGE_Step1/output/{pheno_file}_Step1.varianceRatio.txt       \
                --SAIGEOutputFile=/mnt/disks/data1/SAIGE/SAIGE_Step2/output/chr${chr}_{pheno_file}_output        \
                --LOCO=FALSE

        gsutil cp /mnt/disks/data1/SAIGE/SAIGE_Step2/output/chr${chr}_{pheno_file}_output gs://leelabsg-cloud-test/UKBB/SAIGE_output/
        gsutil cp /mnt/disks/data1/SAIGE/SAIGE_Step2/output/chr${chr}_{pheno_file}_output.index gs://leelabsg-cloud-test/UKBB/SAIGE_output/

        sudo rm /mnt/disks/data1/SAIGE/SAIGE_Step2/ukb_imp_chr${chr}_v3.bgen
        sudo rm /mnt/disks/data1/SAIGE/SAIGE_Step2/ukb_imp_chr${chr}_v3.bgen.bgi &
done

gsutil cp -r /mnt/disks/data1/SAIGE/SAIGE_Step2/output gs://leelabsg-cloud-test/UKBB/SAIGE_output/