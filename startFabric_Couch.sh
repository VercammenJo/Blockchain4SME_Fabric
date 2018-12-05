#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error
set -e

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

starttime=$(date +%s)
CC_SRC_PATH=github.com/banks
# launch network; create channel and join peer to channel
cd ../first-network
./byfn.sh  down
./byfn.sh up -c mychannel -s couchdb

#Interact with CLI...

docker exec -it cli peer chaincode install -n banks -v 1.0 -p github.com/chaincode/Banks

#Instantiate Code...

docker exec -it cli peer chaincode instantiate -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n banks -v 1.0 -c '{"Args":["initLedger"]}' -P "OR ('Org0MSP.peer','Org1MSP.peer')"

docker exec -it cli peer chaincode query -C mychannel -n banks -c '{"Args": ["queryByName","banks" , "US_bank"]}'

