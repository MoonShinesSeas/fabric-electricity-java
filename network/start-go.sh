docker-compose -f docker-compose-go.yaml down

echo "生成组织身份文件"
./bin/cryptogen generate --config=./crypto-config.yaml --output ./crypto-config
echo "生成系统通道初始区块"
./bin/configtxgen -profile TwoOrgsOrdererGenesis -channelID first-channel -outputBlock ./config/genesis.block
echo "生成通道文件"
./bin/configtxgen -profile TwoOrgsChannel -channelID appchannel -outputCreateChannelTx ./config/appchannel.tx
echo "生成锚节点配置更新文件"
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./config/TaobaoAnchor.tx -channelID appchannel -asOrg Taobao

./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./config/JDAnchor.tx -channelID appchannel -asOrg JD
echo "部署 orderer 节点"
docker-compose -f docker-compose-go.yaml up -d
echo "正在等待节点的启动完成，等待3秒"
sleep 3
#
TaobaoPeer0Cli="CORE_PEER_TLS_ENABLED=true CORE_PEER_LOCALMSPID=TaobaoMSP  CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/peer/taobao.com/peers/peer0.taobao.com/tls/ca.crt CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/peer/taobao.com/users/Admin@taobao.com/msp CORE_PEER_ADDRESS=peer0.taobao.com:7051"
#
#export CORE_PEER_TLS_ENABLED=true
#export CORE_PEER_ADDRESS=peer0.taobao.com:7051
#export CORE_PEER_LOCALMSPID=TaobaoMSP
#export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/peer/taobao.com/users/Admin@taobao.com/msp
#export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/peer/taobao.com/peers/peer0.taobao.com/tls/ca.crt

TaobaoPeer1Cli="CORE_PEER_TLS_ENABLED=true CORE_PEER_LOCALMSPID=TaobaoMSP CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/peer/taobao.com/peers/peer1.taobao.com/tls/ca.crt CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/peer/taobao.com/users/Admin@taobao.com/msp CORE_PEER_ADDRESS=peer1.taobao.com:8051"
#
#export CORE_PEER_TLS_ENABLED=true 
#export CORE_PEER_LOCALMSPID=TaobaoMSP 
#export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/peer/taobao.com/peers/peer1.taobao.com/tls/ca.crt 
#export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/peer/taobao.com/users/Admin@taobao.com/msp  
#export CORE_PEER_ADDRESS=peer1.taobao.com:8051

JDPeer0Cli="CORE_PEER_TLS_ENABLED=true CORE_PEER_LOCALMSPID=JDMSP CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/peer/jd.com/peers/peer0.jd.com/tls/ca.crt CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/peer/jd.com/users/Admin@jd.com/msp  CORE_PEER_ADDRESS=peer0.jd.com:9051"

#export CORE_PEER_TLS_ENABLED=true
#export CORE_PEER_ADDRESS=peer0.jd.com:9051
#export CORE_PEER_LOCALMSPID=JDMSP
#export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/peer/jd.com/users/Admin@jd.com/msp
#export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/peer/jd.com/peers/peer0.jd.com/tls/ca.crt

JDPeer1Cli="CORE_PEER_TLS_ENABLED=true CORE_PEER_LOCALMSPID=JDMSP CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/peer/jd.com/peers/peer1.jd.com/tls/ca.crt CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/peer/jd.com/users/Admin@jd.com/msp CORE_PEER_ADDRESS=peer1.jd.com:10051"

#export CORE_PEER_TLS_ENABLED=true 
#export CORE_PEER_LOCALMSPID=JDMSP 
#export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/peer/jd.com/peers/peer1.jd.com/tls/ca.crt 
#export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/peer/jd.com/users/Admin@jd.com/msp 
#export CORE_PEER_ADDRESS=peer1.jd.com:10051

echo "七、创建通道"
docker exec cli bash -c "$TaobaoPeer0Cli peer channel create -o orderer.qq.com:7050 -c appchannel -f /etc/hyperledger/config/appchannel.tx --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem"

echo "八、将所有节点加入通道"
docker exec cli bash -c "$TaobaoPeer0Cli peer channel join -b appchannel.block"
docker exec cli bash -c "$TaobaoPeer1Cli peer channel join -b appchannel.block"
docker exec cli bash -c "$JDPeer0Cli peer channel join -b appchannel.block"
docker exec cli bash -c "$JDPeer1Cli peer channel join -b appchannel.block"
#
echo "九、更新锚节点"
docker exec cli bash -c "$TaobaoPeer0Cli peer channel update -o orderer.qq.com:7050 -c appchannel -f /etc/hyperledger/config/TaobaoAnchor.tx --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem"

docker exec cli bash -c "$JDPeer0Cli peer channel update -o orderer.qq.com:7050 -c appchannel -f /etc/hyperledger/config/JDAnchor.tx --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem"

echo "Package chaincode"
#docker exec cli bash -c "cd /src/chaincode/hyperledger-fabric-contract-java-demo"
#docker exec cli bash -c "mvn compile package -DskipTests -Dmaven.test.skip=true"
#echo "删除编译后产生的 target 目录； src 源代码目录； pom.xml"
#docker exec cli bash -c "mv target/chaincode.jar $PWD"
#docker exec cli bash -c "rm -rf target/ src pom.xml"
docker exec cli bash -c "peer lifecycle chaincode package chaincode.tar.gz --path  ./../../../../../../go/src/chaincode/ --lang golang --label chaincode-go_1"

#peer lifecycle chaincode package hyperledger-fabric-contract-java-demo.tar.gz --path ./hyperledger-fabric-contract-java-demo/ --lang java --label hyperledger-fabric-contract-java-demo_1

# -n 链码名，可以自己随便设置
# -v 版本号
# -p 链码目录，在 /opt/gopath/src/ 目录下
echo "十、安装链码"
#docker exec cli bash -c "$TaobaoPeer0Cli peer chaincode install -n fabric-realty -v 1.0.0 -l golang -p chaincode"
#docker exec cli bash -c "$TaobaoPeer0Cli peer chaincode install -n fabric-realty -v 1.0.0 -l golang -p chaincode"
#
#docker exec cli bash -c "$JDPeer0Cli peer chaincode install -n fabric-realty -v 1.0.0 -l golang -p chaincode"

docker exec cli bash -c "$TaobaoPeer0Cli peer lifecycle chaincode install chaincode.tar.gz"
docker exec cli bash -c "$TaobaoPeer1Cli peer lifecycle chaincode install chaincode.tar.gz"
docker exec cli bash -c "$JDPeer0Cli peer lifecycle chaincode install chaincode.tar.gz"
docker exec cli bash -c "$JDPeer1Cli peer lifecycle chaincode install chaincode.tar.gz"

#peer lifecycle chaincode queryinstalled

echo "在脚本中获取 Package ID"
export PACKAGE_LINE=$(docker exec cli bash -c "$TaobaoPeer0Cli peer lifecycle chaincode queryinstalled | grep \"Package ID:\"")
export PACKAGE_ID=$(echo "$PACKAGE_LINE" | awk '{print substr($3, 1, 82)}')
export CC_PACKAGE_ID=$(echo $PACKAGE_ID | sed 's/.$//')
echo "the output"
echo $CC_PACKAGE_ID

echo "十一、实例化链码"
#docker exec cli bash -c "$TaobaoPeer0Cli peer chaincode instantiate -o orderer.qq.com:7050 -C appchannel -n fabric-realty -l golang -v 1.0.0 -c '{\"Args\":[\"init\"]}' -P \"AND ('TaobaoMSP.member','JDMSP.member')\" --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem"

#peer chaincode instantiate -o <ORDERER_ADDRESS> -C <CHANNEL_NAME> -n <CHAINCODE_NAME> -l <CHAINCODE_LANGUAGE> -v <CHAINCODE_VERSION> -c '{"Args":["<INIT_FUNCTION>", "<INIT_ARG_1>", "<INIT_ARG_2>", ...]}' -P "<ENDORSEMENT_POLICY>" --tls --cafile <ORDERER_CA_FILE>

docker exec cli bash -c "$TaobaoPeer0Cli peer lifecycle chaincode approveformyorg -o orderer.qq.com:7050 --ordererTLSHostnameOverride orderer.qq.com --channelID appchannel --init-required --name chaincode-go_1 --version 1.0.0 --package-id $CC_PACKAGE_ID --sequence 1  --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem"

#docker exec cli bash -c "$TaobaoPeer0Cli peer lifecycle chaincode instantiate -o orderer.qq.com:7050 --tls true --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem appchannel -n fabric-realty -l golang -v 1.0.0 -c '{\"Args\":[\"init\"]}' --signature-policy \"AND ('TaobaoMSP.peer','JDMSP.peer')\" --channel-config-policy \"AND ('TaobaoMSP.admin')\""

#docker exec cli bash -c "$TaobaoPeer0Cli peer lifecycle chaincode queryinstalled"

docker exec cli bash -c "$JDPeer0Cli peer lifecycle chaincode approveformyorg -o orderer.qq.com:7050 --ordererTLSHostnameOverride orderer.qq.com --channelID appchannel --init-required --name chaincode-go_1 --version 1.0.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem"

docker exec cli bash -c "peer lifecycle chaincode checkcommitreadiness --channelID appchannel --name chaincode-go_1 --version 1.0.0 --sequence 1 --init-required --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem --output json"

docker exec cli bash -c "peer lifecycle chaincode commit -o orderer.qq.com:7050 --ordererTLSHostnameOverride orderer.qq.com --channelID appchannel --init-required --name chaincode-go_1 --version 1.0.0 --sequence 1 --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem --peerAddresses peer0.taobao.com:7051 --tlsRootCertFiles /etc/hyperledger/peer/taobao.com/peers/peer0.taobao.com/tls/ca.crt --peerAddresses peer0.jd.com:9051 --tlsRootCertFiles /etc/hyperledger/peer/jd.com/peers/peer0.jd.com/tls/ca.crt"

docker exec cli bash -c "peer lifecycle chaincode querycommitted --channelID appchannel --name chaincode-go_1 --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem"

echo "正在等待链码实例化完成，等待5秒"
sleep 5
docker exec cli bash -c "peer chaincode invoke -o orderer.qq.com:7050 --ordererTLSHostnameOverride orderer.qq.com --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem -C appchannel -n chaincode-go_1 --peerAddresses peer0.taobao.com:7051 --tlsRootCertFiles /etc/hyperledger/peer/taobao.com/peers/peer0.taobao.com/tls/ca.crt --peerAddresses peer0.jd.com:9051 --tlsRootCertFiles /etc/hyperledger/peer/jd.com/peers/peer0.jd.com/tls/ca.crt --isInit -c '{\"Args\":[\"Init\",\"\"]}'"
sleep 5
# 进行链码交互，验证链码是否正确安装及区块链网络能否正常工作
echo "十二、验证链码"
#docker exec cli bash -c "$TaobaoPeer0Cli peer chaincode invoke -C appchannel -n fabric-realty  --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem -c '{\"Args\":[\"hello\"]}'"

#docker exec cli bash -c "$TaobaoPeer0Cli peer chaincode invoke -o orderer.qq.com:7050 --ordererTLSHostnameOverride orderer.qq.com -C appchannel -n fabric-realty  --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem --peerAddresses peer0.taobao.com:7051 --tlsRootCertFiles /etc/hyperledger/peer/taobao.com/peers/peer0.taobao.com/tls/ca.crt -c '{\"Args\":[\"hello\"]}'"

#docker exec cli bash -c "peer chaincode invoke -o orderer.qq.com:7050 --ordererTLSHostnameOverride orderer.qq.com --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem -C appchannel -n chaincode-go_1 --peerAddresses peer0.taobao.com:7051 --tlsRootCertFiles /etc/hyperledger/peer/taobao.com/peers/peer0.taobao.com/tls/ca.crt --peerAddresses peer0.jd.com:9051 --tlsRootCertFiles /etc/hyperledger/peer/jd.com/peers/peer0.jd.com/tls/ca.crt -c '{\"function\":\"createCat\",\"Args\":[\"cat-0\" , \"tom\" ,  \"3\" , \"蓝色\" , \"大懒猫\"]}'"

docker exec cli bash -c "peer chaincode invoke -o orderer.qq.com:7050 --ordererTLSHostnameOverride orderer.qq.com --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem -C appchannel -n chaincode-go_1 --peerAddresses peer0.taobao.com:7051 --tlsRootCertFiles /etc/hyperledger/peer/taobao.com/peers/peer0.taobao.com/tls/ca.crt --peerAddresses peer0.jd.com:9051 --tlsRootCertFiles /etc/hyperledger/peer/jd.com/peers/peer0.jd.com/tls/ca.crt -c '{\"Args\":[\"hello\"]}'"

#docker exec cli bash -c "peer chaincode query -C appchannel -n chaincode-go_1 -c '{\"Args\":[\"hello\"]}'"
docker exec cli bash -c "peer chaincode invoke -o orderer.qq.com:7050 --ordererTLSHostnameOverride orderer.qq.com --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem -C appchannel -n chaincode-go_1 --peerAddresses peer0.taobao.com:7051 --tlsRootCertFiles /etc/hyperledger/peer/taobao.com/peers/peer0.taobao.com/tls/ca.crt --peerAddresses peer0.jd.com:9051 --tlsRootCertFiles /etc/hyperledger/peer/jd.com/peers/peer0.jd.com/tls/ca.crt -c '{\"Args\":[\"queryAccount\"]}'"
#peer chaincode invoke -o orderer.qq.com:7050 --ordererTLSHostnameOverride orderer.qq.com --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem -C appchannel -n chaincode-java_1 --peerAddresses peer0.taobao.com:7051 --tlsRootCertFiles /etc/hyperledger/peer/taobao.com/peers/peer0.taobao.com/tls/ca.crt --peerAddresses peer0.jd.com:9051 --tlsRootCertFiles /etc/hyperledger/peer/jd.com/peers/peer0.jd.com/tls/ca.crt -c '{"function":"createCat","Args":["cat-0" , "tom" ,  "3" , "蓝色" , "大懒猫"]}'

#echo "start CA"
#docker-compose -f docker-compose-ca.yaml up -d

docker exec cli bash -c "peer chaincode invoke -o orderer.qq.com:7050 --ordererTLSHostnameOverride orderer.qq.com --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem -C appchannel -n chaincode-go_1 --peerAddresses peer0.taobao.com:7051 --tlsRootCertFiles /etc/hyperledger/peer/taobao.com/peers/peer0.taobao.com/tls/ca.crt --peerAddresses peer0.jd.com:9051 --tlsRootCertFiles /etc/hyperledger/peer/jd.com/peers/peer0.jd.com/tls/ca.crt -c '{\"Args\":[\"createElectricity\",\"6b86b273ff34\",\"zs\",\"199\",\"2024-2-4\"]}'"

sleep 3

docker exec cli bash -c "peer chaincode invoke -o orderer.qq.com:7050 --ordererTLSHostnameOverride orderer.qq.com --tls --cafile /etc/hyperledger/orderer/qq.com/orderers/orderer.qq.com/msp/tlscacerts/tlsca.qq.com-cert.pem -C appchannel -n chaincode-go_1 --peerAddresses peer0.taobao.com:7051 --tlsRootCertFiles /etc/hyperledger/peer/taobao.com/peers/peer0.taobao.com/tls/ca.crt --peerAddresses peer0.jd.com:9051 --tlsRootCertFiles /etc/hyperledger/peer/jd.com/peers/peer0.jd.com/tls/ca.crt -c '{\"Args\":[\"queryElectricity\"]}'"

