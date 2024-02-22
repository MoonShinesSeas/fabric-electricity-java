package com.fabric.service;

import java.util.EnumSet;
import java.util.Map;
import java.util.concurrent.TimeoutException;

import org.apache.commons.codec.binary.StringUtils;
import org.hyperledger.fabric.gateway.Contract;
import org.hyperledger.fabric.gateway.GatewayException;
import org.hyperledger.fabric.gateway.Network;
import org.hyperledger.fabric.sdk.Peer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.google.common.collect.Maps;

@Service
public class ElectricityService {
    @Autowired
    private Client client;

    public Map<String, Object> createElectricity(String owner,
            String manufacturers,
            String quantity,
            String time) throws GatewayException, InterruptedException, TimeoutException, Exception {
        Contract contract = client.contract();
        Network network = client.network();
        Map<String, Object> result = Maps.newConcurrentMap();
        // byte[] transaction = contract.createTransaction("createElectricity")
        //         .setEndorsingPeers(network.getChannel().getPeers(EnumSet.of(Peer.PeerRole.ENDORSING_PEER)))
        //         .submit(owner, manufacturers, quantity, time);
        // contract.submitTransaction("createElectricity", "d4735e3a265e", "zm", "257", "2024-2-20");
        byte[] transaction = contract.createTransaction("createElectricity")
        .submit(owner, manufacturers, quantity, time);
        System.out.println(transaction);
        result.put("payload",
                StringUtils.newStringUtf8(contract.evaluateTransaction("queryElectricityByOwner", owner)));
        result.put("status", "ok");
        return result;
    }

    public Map<String, Object> queryElectricity(String owner)
            throws GatewayException, Exception {
        Contract contract = client.contract();
        Map<String, Object> result = Maps.newConcurrentMap();
        byte[] res = contract.evaluateTransaction("queryElectricityByOwner", owner);
        result.put("payload", StringUtils.newStringUtf8(res));
        result.put("status", "ok");
        return result;
    }
}
