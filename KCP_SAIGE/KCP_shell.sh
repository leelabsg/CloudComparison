#!/bin/bash

timestamp=$(date)"step0start"
echo ${timestamp}

cd /home/ubuntu/step1

timestamp=$(date)"step0start"
echo ${timestamp}

docker run -w /home/ubuntu/step1 -v /home/ubuntu/step1/:/home/ubuntu/step1/ wzhou88/saige:1.3.0 createSparseGRM.R --plinkFile=/home/ubuntu/step1/UKB_step1       --nThreads=4   --outputPrefix=/home/ubuntu/step1/sparseGRM --numRandomMarkerforSparseKin=2000 --relatednessCutoff=0.125

timestamp=$(date)"step0end"
echo ${timestamp}

mkdir /home/ubuntu/step1/output
mkdir /home/ubuntu/step2/output
timestamp=$(date)"step1start"
echo ${timestamp}
docker run -w /home/ubuntu/step1 -v /home/ubuntu/step1/:/home/ubuntu/step1/ wzhou88/saige:1.3.0 step1_fitNULLGLMM.R \
--useSparseGRMtoFitNULL=TRUE \
--sparseGRMFile=/home/ubuntu/step1/sparseGRM_relatednessCutoff_0.125_2000_randomMarkersUsed.sparseGRM.mtx \
--sparseGRMSampleIDFile=/home/ubuntu/step1/sparseGRM_relatednessCutoff_0.125_2000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt \
--plinkFile=/home/ubuntu/step1/UKB_step1 \
--phenoFile=/home/ubuntu/step1/HDL_imputed_pheno.txt \
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

timestamp=$(date)"step1end"
echo ${timestamp}

cd /home/ubuntu

timestamp=$(date)"step2start"
echo ${timestamp}
docker run -w /home/ubuntu/ -v /home/ubuntu/:/home/ubuntu/ wzhou88/saige:1.3.0 step2_SPAtests.R   \
--bgenFile=/home/ubuntu/step2/ukb_imp_chr22_v3.bgen \
--bgenFileIndex=/home/ubuntu/step2/ukb_imp_chr22_v3.bgen.bgi        \
--minMAF=0.0001 \
--minMAC=10     \
--chrom=22  \
--GMMATmodelFile=/home/ubuntu/step1/output/HDL_imputed_Step1.rda        \
--sampleFile=/home/ubuntu/step2/ukb45227_imp_chr1_v3_s487296.sample     \
--varianceRatioFile=/home/ubuntu/step1/output/HDL_imputed_Step1.varianceRatio.txt       \
--SAIGEOutputFile=/home/ubuntu/step2/output/chr22_HDL_imputed_output        \
--LOCO=FALSE
timestamp=$(date)"step2end"
echo ${timestamp}
