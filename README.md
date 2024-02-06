# CloudComparison

## 네이버 클라우드

### 네이버 클라우드 환경 아키텍쳐

<figure>
    <img src="/NCP_SAIGE/doc/NCPArchitecture.png" title="네이버 클라우드 환경 아키텍쳐">    
    <figcaption><b>[네이버 클라우드 환경 아키텍쳐]</b></figcaption>
</figure>

- 네이버 클라우드 환경의 아키텍쳐는 위 그림과 같다.   
- 호스트 서버: _"ssh -p 1028 root@27.96.129.251"_ 를 이용하여 접속 가능. 비밀번호는 _"flfoq"_(리랩). 스펙은 [Standard] 2vCPU, 4GB Mem, 50GB Disk [g1]이며, VM 인스턴스 생성을 위해 쓰인다.   
- 오브젝트 스토리지: SAIGE를 돌릴 때 사용되는 많은 양의 데이터를 저장하기 위한 저장공간. aws cli를 호환한다. _"https://cli-gov.ncloud-docs.com/docs/guide-objectstorage"_ 참고   
- VM 인스턴스: 실제 SAIGE를 돌리기 위해 생성되는 VM 인스턴스. 깃허브 CloudComparison의 _"/NCP_SAIGE/NCP_Init/NCP_InitCall.sh"_ 는 서버 이미지 Ubuntu Server 18.04 (64-bit)인, [Standard] 4vCPU, 32GB Mem, 50GB Disk [g1] 스펙의 VM 인스턴스를 생성한다. 다만, Ubuntu Server 18.04 (64-bit)는 최근에 4월 30일까지만 서비스 이용이 가능하다고 공지가 내려졌다.
- 블록 스토리지: VM 인스턴스에 직접적으로 부착이 가능한 스토리지. 인스턴스 시작 시 생성하고, 인스턴스 위에 마운트하며, 인스턴스 반환 전에 언마운트하고, 스토리지를 반환한다. 마운트, 언마운트 관련 방법에 대한 자료는 _"https://guide-gov.ncloud-docs.com/docs/compute-compute-4-1-v2"_ 참고. init script에 cli로 언마운트 되게 하였다. cli를 이용하여 스토리지 반환하는 방법은 _"/NCP_SAIGE/NCP_Init/NCP_InitCall.sh"_ 에 있다.

### Some useful information about Naver Cloud Platform

- 네이버 클라우드 플랫폼의 서비스는 크게 VPC와 classic으로 나누어져 있다.
    * classic 장점 요약
        + 서로 다른 계정의 서버들 간에 사설 통신 가능
        + 리전간 서버들의 사설 통신 가능 (한국, 미국, 싱가포르, 홍콩, 일본, 독일)
        + 다양한 설치형 서버 이미지 이용 가능
    * VPC 장점 요약
        + 논리적으로 분리된 Network
        + 사용자가 직접 Network 설계 가능
        + 기존 고객의 데이터센터 네트워크와 유사하게 구현 가능
        + 좀 더 상세하고, 높은 수준의 보안 설정 가능
    * (출처: _"https://docs.3rdeyesys.com/management/ncloud_management_classic_vs_vpc_guide.html"_)
- cli 가이드는 _"https://cli.ncloud-docs.com/docs/home"_ 를 참고. VPC와 classic에 따라 cli가 차이가 나는 점에 대해서 주의가 필요하다.
> VPC cli 예: ./ncloud vserver getServerInstanceList --regionCode KR --vpcNo ***04 --serverInstanceNoList ***4299 --serverName test-*** --serverInstanceStatusCode RUN --baseBlockStorageDiskTypeCode NET --baseBlockStorageDiskDetailTypeCode SSD --ip ***.***.111.215 --placementGroupNoList ***61

> classic cli 예: ./ncloud server getServerInstanceList --serverInstanceStatusCode NSTOP --regionNo 2

- 현재 호스트 서버에는 cli가 깔려 있지만, 다른 호스트 서버를 구축하려면, cli를 _"https://cli.ncloud-docs.com/docs/guide-clichange"_ 에서 다운받은 뒤에 호스트 서버로 옮겨야 한다.
- **현재 호스트 서버는 classic 서버이고, _"NCP_SAIGE/NCP_Init/NCP_InitCall.sh"_ 은 classic 서버를 생성되도록 하고 있다.**
- cli를 이용할 때에는 cli가 위치한 디렉토리에 이동하여 "./ncloud {명령 내용}" (ex: ./ncloud server getServerInstanceList --serverInstanceStatusCode NSTOP --regionNo 2) 과 같은 방식으로 cli를 사용한다.

- VPC가 classic 보다 더 많은 api와 cli 커멘드를 지원하고 있으며, init script를 cli 상에서 등록하는 것은 VPC 서비스에서만 지원된다.
<figure>
    <img src="/NCP_SAIGE/doc/init_script.png" title="init_script.png">    
    <figcaption><b>[init_script 설명 이미지]</b></figcaption>
</figure>


- classic을 사용하고 있다면, GUI 콘솔 상에서만 init script를 등록할 수 있다. 콘솔 > Services > Compute > Server > Init Script 로 이동하면 위 이미지의 창이 뜬다. Script 생성 버튼을 이용하여 init script를 등록할 수 있다.
- 이미 등록된 init script를 cli 상에서 사용하려면 init script의 번호를 찾아야 한다. getInitScriptList를 이용하여 init script 번호를 알 수 있다. (classic: _"https://cli.ncloud-docs.com/docs/cli-server-getinitscriptlist"_, VPC: _"https://cli.ncloud-docs.com/docs/cli-vserver-initscript-getinitscriptlist"_)
- init script 번호를 안다면, VM 인스턴스를 생성할 때, 해당 번호를 전달하여, 자동으로 shell script가 생성과 동시에 실행되도록 할 수 있다. 만약, 서버에서 init script가 잘 돌아가는지 보고 싶으면, 생성된 인스턴스에 들어가도 init script가 중단되지 않으니, 걱정하지 않아도 된다.

<figure>
    <img src="/NCP_SAIGE/doc/server_setting.png" title="server_setting.png">    
    <figcaption><b>[첫 서버에 접속하는 법]</b></figcaption>
</figure>


- 새로 생성된 서버에 들어가 보려면 콘솔 > Service > Compute > Server 로 이동하여, 생성된 서버의 체크박스를 체크 한 뒤, "서버 관리 및 설정 변경" 을 선택하여 "관리자 비밀번호 확인"을 누른다. 이를 통해, 무작위로 생성된 서버의 임시 비밀번호를 알 수 있다. 이때 CloudComparison에 있는 _"/pem_certificate/naver/aaa.pem"_ 파일이 필요하다. 관리자 비밀번호를 메모장에 저장해 둔다. 위 이미지의 네모 박스, 포트 포워딩 설정은 VM 인스턴스를 공용 ip의 port에 연결하기 위해서 해 주는 것이다. 1,024~65,534 범위의 숫자가 중복되지 않게 설정하면 된다.
- 관련 도큐먼트는 다음과 같다. 부족한 정보가 있으면 참고. _"https://guide.ncloud-docs.com/docs/server-manage-classic#포트포워딩설정"_, _"https://guide.ncloud-docs.com/docs/server-access-classic_", "_https://guide.ncloud-docs.com/docs/server-publicip-classic_"

- 추가적으로 유용한 naver cloud cli 명령어들은 다음과 같다.
    + getServerImageProductList: NCP에서 제공하는 서버 이미지(OS)의 리스트를 반환
    + getServerProductList: NCP에서 제공하는 서버 제품들의 리스트를 반환 (메모리, vCPU 수, SSD/HDD 크기에 따라 다양하게 분류된다.)
    + getServerInstanceList: 현재 내가 만들어서 사용하고 있는 서버들을 반환.
    + createServerInstances: 서버 인스턴스 생성
    + terminateServerInstances: 서버 인스턴스 반납 (정지된 인스턴스만 반납 가능)
    + stopServerInstances: 서버 인스턴스 정지
    + getInitScriptList: 나의 init script 리스트 반환
    + getRootPassword: 서버의 루트 계정의 비밀번호를 조회. cli를 사용 중인 서버 상에 인증pem 파일이 있어야 가능하다.
    + getBlockStorageInstanceList: 블록 스토리지 리스트를 반환. 블록 스토리지의 number(blockStorageInstanceNo)를 찾을 때 사용. serverInstanceNo를 보고 어떤 서버에 묶여있는지 확인 가능.
    + createBlockStorageInstance: 블록 스토리지 생성. 생성 후 마운트를 해 주어야 한다.
    + deleteBlockStorageInstances: 블록 스토리지 삭제.
    + attachBlockStorageInstance: 서버에 블록 스토리지를 붙인다. 해당 cli를 써 보진 않았음. init script 상에서는 서버에서 직접 마운트하는 방법을 사용.
    + detachBlockStorageInstances: 서버에 블록 스토리지를 띈다. 해당 cli를 써 보진 않았음. init script 상에서는 서버에서 직접 언마운트하는 방법을 사용.
    + 호환 cli: _"https://cli.ncloud-docs.com/docs/guide-objectstorage"_ 참고. aws cli를 이용하여, NCP의 object storage에서 데이터를 받아올 때 사용.



### 현재 발견한 네이버 클라우드 문제점들
- GCP나 카카오 클라우드 플랫폼과 다르게, 블록 스토리지를 연결하려면 마운트 과정이 필요하여 불편한 면이 있다. GCP의 경우 블록 스토리지의 사이즈를 인스턴스 생성과 함께 명시한다는 점이 간단하고, 카카오 클라우드도 콘솔 상에서 스토리지를 함께 생성시킨다.
- init script가 OS(ServerImageProduct)가 Ubuntu Server 18.04 (64-bit)가 아닌 "productCode": "SPSW0LINUX000063", "productName": "redis(3.2.8)-ubuntu-14.04-64-server"에서는 오류가 발생한다는 것을 알게 되었다. Ubuntu Server 18.04 (64-bit)는 4월 30일까지만 서비스 제공.
> 오류는 처음에는 jq 명령어를 못 찾는 오류였고, 서버에 직접 접속하여 하나하나 cli를 다시 시도하니 되었다. 다만 apt install python-pip -y, pip install awscli==1.15.85 라인에서 다시 오류가 발생하는 것으로 보아, OS 별로 install 방식이 다른 데에서 기인한 것으로 보임.
- classic 서비스 이용시 init script 생성을 cli 상에서 불가.
- SAIGE가 끝나고, 자동 반환이 불가능하다. 이는 서버 반환을 하려면 서버 종료를 해야 하는데, 종료된 서버는 자체 반환이 안 되는 데에서 기인한다. 네이버 클라우드 서비스 질문 남기기에 해당 문제에 대해 물어봤지만, 해결은 불가능해 보인다. 아래는 네이버 측 답변.
> 안녕하세요. 네이버 클라우드 플랫폼입니다.
> 
> 서버 반납을 위해서는 서버 정지가 먼저 이루어져야 합니다.
> 말씀하신 대로 서버 내에서의 반납은 정지가 선행이기에 반납까지의 절차는 진행이 어려워 보입니다.
> 
> 불편하시겠지만, CLI 를 이용하신다면 별도의 API 서버를 활용하시는 것이 좋겠습니다.
>  
> 감사합니다.

### 네이버 클라우드 실험 결과
- 서버 이미지 Ubuntu Server 18.04 (64-bit)인, [Standard] 4vCPU, 32GB Mem, 50GB Disk [g1] 스펙의 VM 인스턴스로 두 번의 실험을 하였다.
    + ./ncloud server createServerInstances --serverImageProductCode SPSW0LINUX000130 --serverProductCode SPSVRSSD00000013 --serverName mktest --initScriptNo 72828
- 1차 시도
    + Step0: 7시간
    + Step1: 0.5시간
    + Step2: chrom22로 4.45시간 (총 expected 시간 = 328.5시간)
- 2차 시도
    + Step0: 7시간
    + Step1: 0.5시간
    + Step2: chrom22로 4.5시간 (총 expected 시간 = 333.6시간)



```bash
#!/bin/bash
set -e
exec > >(tee /var/log/startup-script.log) 2>&1
timestamp=$(date)"start"
echo ${timestamp}
curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/local/bin/jq
chmod a+x /usr/local/bin/jq

apt install sshpass
sshpass -p 'flfoq' scp -o StrictHostKeyChecking=no -P 1028 -r root@27.96.129.251:/root/cli_linux /root/
cd /root/cli_linux

export AWS_ACCESS_KEY_ID="JcWpzzSYISiipUCMlqsH"
export AWS_SECRET_ACCESS_KEY="k6FfwQ4gRxkGQQ9xvWUQX559E4X0xY00gd2VmF2h"
echo -e "${AWS_ACCESS_KEY_ID}\n${AWS_SECRET_ACCESS_KEY}\n\n" | ./ncloud configure

serverInstanceNo=$(./ncloud server getServerInstanceList | jq -r '.getServerInstanceListResponse.serverInstanceList[] | select(.serverName == "mktest") | .serverInstanceNo')

apt install python-pip -y
pip install awscli==1.15.85

echo -e "${AWS_ACCESS_KEY_ID}\n${AWS_SECRET_ACCESS_KEY}\n\n" | aws configure

blockInstanceNo=$(./ncloud server createBlockStorageInstance --blockStorageSize 500 --serverInstanceNo ${serverInstanceNo} | jq -r  '.createBlockStorageInstanceResponse.blockStorageInstanceList[] | select(.serverName == "mktest") | .blockStorageInstanceNo')
DIRECTORY="/dev/xvdb"
while true; do
    if [ -e "$DIRECTORY" ]; then
        echo "Can't find directory"
        break
    else
        echo "Found directory"
    fi
    sleep 5
done
echo "escape while loop"

echo -e "n\np\n\n\n\nw\n" | fdisk /dev/xvdb
mkfs.ext4 /dev/xvdb1
mkdir /mnt/a
mount /dev/xvdb1 /mnt/a
DIRECTORY="/mnt/a"
while true; do
    if [ -e "$DIRECTORY" ]; then
        echo "Can't find directory"
        break
    else
        echo "Found directory"
    fi
    sleep 5
done
echo "escape while loop"

mkdir -p /mnt/a/data1/SAIGE/SAIGE_Step1/
mkdir -p /mnt/a/data1/SAIGE/SAIGE_Step2/output

aws --endpoint-url=https://kr.object.ncloudstorage.com s3api get-object --bucket leelabsgtest --key UKB_step1.fam  /mnt/a/data1/SAIGE/SAIGE_Step1/UKB_step1.fam
aws --endpoint-url=https://kr.object.ncloudstorage.com s3api get-object --bucket leelabsgtest --key UKB_step1.bed  /mnt/a/data1/SAIGE/SAIGE_Step1/UKB_step1.bed
aws --endpoint-url=https://kr.object.ncloudstorage.com s3api get-object --bucket leelabsgtest --key UKB_step1.bim  /mnt/a/data1/SAIGE/SAIGE_Step1/UKB_step1.bim

cd /root
sudo apt-get update
sudo apt-get install docker.io -y

newgrp docker
docker pull wzhou88/saige:1.3.0

cd /mnt/a/data1/SAIGE/SAIGE_Step1
timestamp=$(date)"step0start"
echo ${timestamp}
docker run -w /mnt/a/data1/SAIGE/SAIGE_Step1 -v /mnt/a/data1/SAIGE/SAIGE_Step1/:/mnt/a/data1/SAIGE/SAIGE_Step1/ wzhou88/saige:1.3.0 createSparseGRM.R --plinkFile=/mnt/a/data1/SAIGE/SAIGE_Step1/UKB_step1       --nThreads=4   --outputPrefix=/mnt/a/data1/SAIGE/SAIGE_Step1/sparseGRM --numRandomMarkerforSparseKin=2000 --relatednessCutoff=0.125
timestamp=$(date)"step0end"
echo ${timestamp}
aws --endpoint-url=https://kr.object.ncloudstorage.com s3api get-object --bucket leelabsgtest --key HDL_imputed_pheno.txt /mnt/a/data1/SAIGE/SAIGE_Step1/HDL_imputed_pheno.txt

mkdir /mnt/a/data1/SAIGE/SAIGE_Step1/output
timestamp=$(date)"step1start"
echo ${timestamp}
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

timestamp=$(date)"step1end"
echo ${timestamp}

cd /mnt/a/data1/SAIGE/SAIGE_Step2

aws --endpoint-url=https://kr.object.ncloudstorage.com s3api get-object --bucket leelabsgtest --key ukb45227_imp_chr1_v3_s487296.sample /mnt/a/data1/SAIGE/SAIGE_Step2/ukb45227_imp_chr1_v3_s487296.sample
timestamp=$(date)"step2start"
echo ${timestamp}
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
timestamp=$(date)"step2end"
echo ${timestamp}
for ((chr=1; chr<=22; chr++))
do
 aws --endpoint-url=https://kr.object.ncloudstorage.com s3api put-object --bucket leelabsgtest --key chr${chr}_HDL_imputed_output --body /mnt/a/data1/SAIGE/SAIGE_Step2/output/chr${chr}_HDL_imputed_output
 aws --endpoint-url=https://kr.object.ncloudstorage.com s3api put-object --bucket leelabsgtest --key chr${chr}_HDL_imputed_output.index --body /mnt/a/data1/SAIGE/SAIGE_Step2/output/chr${chr}_HDL_imputed_output.index
done

umount -l /mnt/a
```
