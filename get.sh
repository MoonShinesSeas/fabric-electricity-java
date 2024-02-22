#peer lifecycle chaincode queryinstalled
TaobaoPeer0Cli="CORE_PEER_TLS_ENABLED=true CORE_PEER_LOCALMSPID=TaobaoMSP  CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/peer/taobao.com/peers/peer0.taobao.com/tls/ca.crt CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/peer/taobao.com/users/Admin@taobao.com/msp CORE_PEER_ADDRESS=peer0.taobao.com:7051"

echo "在脚本中获取 Package ID"
export PACKAGE_LINE=$(docker exec cli bash -c "$TaobaoPeer0Cli peer lifecycle chaincode queryinstalled | grep \"Package ID:\"")
echo "the output"
echo $PACKAGE_LINE
export PACKAGE_ID=$(echo "$PACKAGE_LINE" | awk '{print substr($3, 1, 82)}')
export CC_PACKAGE_ID=$(echo $PACKAGE_ID | sed 's/.$//')
echo $CC_PACKAGE_ID
