#!/bin/bash
set -e
exec > >(tee /var/log/startup-script.log) 2>&1
curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/local/bin/jq
chmod a+x /usr/local/bin/jq

apt install sshpass
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r root@27.96.129.251:/root/cli_linux /root/
cd /root/cli_linux
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
export AWS_ACCESS_KEY_ID="JcWpzzSYISiipUCMlqsH"
export AWS_SECRET_ACCESS_KEY="k6FfwQ4gRxkGQQ9xvWUQX559E4X0xY00gd2VmF2h"
echo -e "${AWS_ACCESS_KEY_ID}\n${AWS_SECRET_ACCESS_KEY}\n\n" | ./ncloud configure
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
serverInstanceNo=$(./ncloud server getServerInstanceList | jq -r '.getServerInstanceListResponse.serverInstanceList[] | select(.serverName == "mktest") | .serverInstanceNo')
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
apt install python-pip -y
pip install awscli==1.15.85
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
echo -e "${AWS_ACCESS_KEY_ID}\n${AWS_SECRET_ACCESS_KEY}\n\n" | aws configure
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
blockInstanceNo=$(./ncloud server createBlockStorageInstance --blockStorageSize 500 --serverInstanceNo ${serverInstanceNo} | jq -r  '.createBlockStorageInstanceResponse.blockStorageInstanceList[] | select(.serverName == "mktest") | .blockStorageInstanceNo')
DIRECTORY="/dev/xvdb"
while true; do
    if [ -e "$DIRECTORY" ]; then
        echo "Found directory"
        break
    else
        echo "Can't find directory"
    fi
    sleep 5
done
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
echo "escape while loop"
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
echo -e "n\np\n\n\n\nw\n" | fdisk /dev/xvdb
mkfs.ext4 /dev/xvdb1
mkdir /mnt/a
mount /dev/xvdb1 /mnt/a
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
DIRECTORY="/mnt/a"
while true; do
    if [ -e "$DIRECTORY" ]; then
        echo "Found directory"
        break
    else
        echo "Can't find directory"
    fi
    sleep 5
done
echo "escape while loop"
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
mkdir -p /mnt/a/data1/SAIGE/SAIGE_Step1/
mkdir -p /mnt/a/data1/SAIGE/SAIGE_Step2/output
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
aws --endpoint-url=https://kr.object.ncloudstorage.com s3api get-object --bucket leelabsgtest --key UKB_step1.fam  /mnt/a/data1/SAIGE/SAIGE_Step1/UKB_step1.fam
aws --endpoint-url=https://kr.object.ncloudstorage.com s3api get-object --bucket leelabsgtest --key UKB_step1.bed  /mnt/a/data1/SAIGE/SAIGE_Step1/UKB_step1.bed
aws --endpoint-url=https://kr.object.ncloudstorage.com s3api get-object --bucket leelabsgtest --key UKB_step1.bim  /mnt/a/data1/SAIGE/SAIGE_Step1/UKB_step1.bim
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
cd /root
sudo apt-get update
sudo apt-get install docker.io -y
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
newgrp docker
docker pull wzhou88/saige:1.3.0
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
cd /mnt/a/data1/SAIGE/SAIGE_Step1
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
docker run -w /mnt/a/data1/SAIGE/SAIGE_Step1 -v /mnt/a/data1/SAIGE/SAIGE_Step1/:/mnt/a/data1/SAIGE/SAIGE_Step1/ wzhou88/saige:1.3.0 createSparseGRM.R --plinkFile=/mnt/a/data1/SAIGE/SAIGE_Step1/UKB_step1       --nThreads=4   --outputPrefix=/mnt/a/data1/SAIGE/SAIGE_Step1/sparseGRM --numRandomMarkerforSparseKin=2000 --relatednessCutoff=0.125

aws --endpoint-url=https://kr.object.ncloudstorage.com s3api get-object --bucket leelabsgtest --key HDL_imputed_pheno.txt /mnt/a/data1/SAIGE/SAIGE_Step1/HDL_imputed_pheno.txt

mkdir /mnt/a/data1/SAIGE/SAIGE_Step1/output
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
docker run -w /mnt/a/data1/SAIGE/SAIGE_Step1 -v /mnt/a/data1/SAIGE/SAIGE_Step1/:/mnt/a/data1/SAIGE/SAIGE_Step1/ wzhou88/saige:1.3.0 step1_fitNULLGLMM.R \
--useSparseGRMtoFitNULL=TRUE \
--sparseGRMFile=/mnt/a/data1/SAIGE/SAIGE_Step1/sparseGRM_relatednessCutoff_0.125_2000_randomMarkersUsed.sparseGRM.mtx \
--sparseGRMSampleIDFile=/mnt/a/data1/SAIGE/SAIGE_Step1/sparseGRM_relatednessCutoff_0.125_2000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt \
--plinkFile=/mnt/a/data1/SAIGE/SAIGE_Step1/UKB_step1 \
--phenoFile=/mnt/a/data1/SAIGE/SAIGE_Step1/HDL_imputed_pheno.txt \
--phenoCol=HDL \
--covarColList=Sex,Age,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10  \
--sampleIDColinphenoFile=eid  \
--traitType=quantitative \
--invNormalize=TRUE \
--outputPrefix=./output/HDL_imputed_Step1 \
--nThreads=4 \
--LOCO=TRUE \
--FemaleCode=2 \
--MaleCode=1 \
--IsOverwriteVarianceRatioFile=TRUE

cd /mnt/a/data1/SAIGE/SAIGE_Step2

aws --endpoint-url=https://kr.object.ncloudstorage.com s3api get-object --bucket leelabsgtest --key ukb45227_imp_chr1_v3_s487296.sample /mnt/a/data1/SAIGE/SAIGE_Step2/ukb45227_imp_chr1_v3_s487296.sample

sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r /var/log/startup-script.log root@27.96.129.251:/root/
for ((chr=1; chr<=22; chr++))
do
aws --endpoint-url=https://kr.object.ncloudstorage.com s3api get-object --bucket leelabsgtest --key ukb_imp_chr${chr}_v3.bgen.bgi /mnt/a/data1/SAIGE/SAIGE_Step2/ukb_imp_chr${chr}_v3.bgen.bgi
aws --endpoint-url=https://kr.object.ncloudstorage.com s3api get-object --bucket leelabsgtest --key ukb_imp_chr${chr}_v3.bgen /mnt/a/data1/SAIGE/SAIGE_Step2/ukb_imp_chr${chr}_v3.bgen


docker run -w /mnt/a/data1/SAIGE/ -v /mnt/a/data1/SAIGE/:/mnt/a/data1/SAIGE/ wzhou88/saige:1.3.0 step2_SPAtests.R   \
--bgenFile=/mnt/a/data1/SAIGE/SAIGE_Step2/ukb_imp_chr${chr}_v3.bgen \
--bgenFileIndex=/mnt/a/data1/SAIGE/SAIGE_Step2/ukb_imp_chr${chr}_v3.bgen.bgi        \
--minMAF=0.0001 \
--minMAC=10     \
"--chrom="$(printf "%02d" $chr)  \
--GMMATmodelFile=/mnt/a/data1/SAIGE/SAIGE_Step1/output/HDL_imputed_Step1.rda        \
--sampleFile=/mnt/a/data1/SAIGE/SAIGE_Step2/ukb45227_imp_chr1_v3_s487296.sample     \
--varianceRatioFile=/mnt/a/data1/SAIGE/SAIGE_Step1/output/HDL_imputed_Step1.varianceRatio.txt       \
--SAIGEOutputFile=/mnt/a/data1/SAIGE/SAIGE_Step2/output/chr${chr}_HDL_imputed_output        \
--LOCO=FALSE

rm /mnt/a/data1/SAIGE/SAIGE_Step2/ukb_imp_chr${chr}_v3.bgen
rm /mnt/a/data1/SAIGE/SAIGE_Step2/ukb_imp_chr${chr}_v3.bgen.bgi
done

for ((chr=1; chr<=22; chr++))
do
 aws --endpoint-url=https://kr.object.ncloudstorage.com s3api put-object --bucket leelabsgtest --key chr${chr}_HDL_imputed_output --body /mnt/a/data1/SAIGE/SAIGE_Step2/output/chr${chr}_HDL_imputed_output
 aws --endpoint-url=https://kr.object.ncloudstorage.com s3api put-object --bucket leelabsgtest --key chr${chr}_HDL_imputed_output.index --body /mnt/a/data1/SAIGE/SAIGE_Step2/output/chr${chr}_HDL_imputed_output.index

done
sleep 5
umount -l /mnt/a
