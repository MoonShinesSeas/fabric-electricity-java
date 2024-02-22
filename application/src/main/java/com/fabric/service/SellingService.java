package com.fabric.service;

import java.util.EnumSet;
import java.util.Map;
import java.util.concurrent.TimeoutException;

import org.apache.commons.codec.binary.StringUtils;
import org.hyperledger.fabric.gateway.Contract;
import org.hyperledger.fabric.gateway.ContractException;
import org.hyperledger.fabric.gateway.GatewayException;
import org.hyperledger.fabric.gateway.Network;
import org.hyperledger.fabric.sdk.Peer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.google.common.collect.Maps;

@Service
public class SellingService {
    @Autowired
    private Client client;

    public Map<String, Object> querySellingList() throws GatewayException, Exception {
        Contract contract = client.contract();
        Network network = client.network();
        Map<String, Object> result = Maps.newConcurrentMap();
        byte[] res = contract.evaluateTransaction("querySellingList");
        result.put("payload", StringUtils.newStringUtf8(res));
        result.put("status", "ok");
        return result;
    }

    public Map<String, Object> querySellingByBuyer(String buyer)
            throws GatewayException, TimeoutException, InterruptedException, Exception {
        Contract contract = client.contract();
        Network network = client.network();
        Map<String, Object> result = Maps.newConcurrentMap();
        // byte[] transcation = contract.createTransaction("querySellingByBuyer")
        // .setEndorsingPeers(network.getChannel().getPeers(EnumSet.of(Peer.PeerRole.ENDORSING_PEER)))
        // .submit(buyer);
        byte[] transcation = contract.createTransaction("querySellingByBuyer")
                .submit(buyer);
        result.put("payload", StringUtils.newStringUtf8(transcation));
        result.put("status", "ok");
        return result;
    }

    public Map<String, Object> createSelling(String electricityID,
            String seller,
            String price,
            String saleperiod)
            throws GatewayException, TimeoutException, InterruptedException, Exception {
        Contract contract = client.contract();
        Map<String, Object> result = Maps.newConcurrentMap();
        // byte[] transaction = contract.createTransaction("createSelling")
        // .setEndorsingPeers(network.getChannel().getPeers(EnumSet.of(Peer.PeerRole.ENDORSING_PEER)))
        // .submit(electricityID, seller, price, saleperiod);
        byte[] transcation = contract.createTransaction("createSelling")
                .submit(electricityID, seller, price, saleperiod);
        result.put("payload", StringUtils.newStringUtf8(contract.evaluateTransaction("querySellingList")));
        result.put("status", "ok");
        return result;
    }

    public Map<String, Object> buy(String electricityID,
            String seller,
            String buyer)
            throws GatewayException, TimeoutException, InterruptedException, Exception {
        Contract contract = client.contract();
        Network network = client.network();
        Map<String, Object> result = Maps.newConcurrentMap();
        // byte[] transcation = contract.createTransaction("createSellingByBuy")
        // .setEndorsingPeers(network.getChannel().getPeers(EnumSet.of(Peer.PeerRole.ENDORSING_PEER)))
        // .submit(electricityID, seller, buyer);
        byte[] transcation = contract.createTransaction("createSellingByBuy")
                .submit(electricityID, seller, buyer);
        result.put("payload", StringUtils.newStringUtf8(contract.evaluateTransaction("querySellingList")));
        result.put("status", "ok");
        return result;
    }

    public Map<String, Object> updateSelling(String electricityID,
            String seller,
            String buyer,
            String status)
            throws GatewayException, TimeoutException, InterruptedException, ContractException, Exception {
        Contract contract = client.contract();
        Map<String, Object> result = Maps.newConcurrentMap();
        byte[] transcation = contract.submitTransaction("updateSelling", electricityID, seller, buyer, status);
        result.put("payload", StringUtils.newStringUtf8(contract.evaluateTransaction("querySellingList", seller)));
        result.put("status", "ok");
        return result;
    }

    public Map<String, Object> queryHistory(String marblename)
            throws GatewayException, TimeoutException, InterruptedException, Exception {
        Contract contract = client.contract();
        Map<String, Object> result = Maps.newConcurrentMap();
        byte[] transcation = contract.submitTransaction("queryHistory", marblename);
        result.put("payload", StringUtils.newStringUtf8(transcation));
        result.put("status", "ok");
        return result;
    }
}
