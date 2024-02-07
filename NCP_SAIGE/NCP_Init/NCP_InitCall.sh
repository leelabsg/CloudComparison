./ncloud server getServerProductList --serverImageProductCode SPSW0LINUX000130
./ncloud server createServerInstances --serverImageProductCode SPSW0LINUX000130 --serverProductCode SPSVRSSD00000013 --serverName mktest --initScriptNo 72828

##############################################################################################################
# 위의 명령이 async하게 떨어집니다. init script 실행이 모두 완료되었는지를 확인하고 아래의 절차를 진행해 주세요.
# jq가 먼저 설치가 되어져야 합니다.
# curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/local/bin/jq
# chmod a+x /usr/local/bin/jq
##############################################################################################################
serverInstanceNo=$(./ncloud server getServerInstanceList | jq -r '.getServerInstanceListResponse.serverInstanceList[] | select(.serverName == "mktest") | .serverInstanceNo')

blockInstanceNo=$(./ncloud server getBlockStorageInstanceList | jq -r '.getBlockStorageInstanceListResponse.blockStorageInstanceList[] | select(.serverName == "mktest" and .deviceName == "/dev/xvdb") | .blockStorageInstanceNo')
./ncloud server deleteBlockStorageInstances --blockStorageInstanceNoList ${blockInstanceNo}

./ncloud server stopServerInstances --serverInstanceNoList ${serverInstanceNo}
./ncloud server terminateServerInstances --serverInstanceNoList ${serverInstanceNo} 
