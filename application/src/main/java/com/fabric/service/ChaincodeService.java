package com.fabric.service;

import java.util.Map;

import org.apache.commons.codec.binary.StringUtils;
import org.hyperledger.fabric.gateway.Contract;
import org.hyperledger.fabric.gateway.GatewayException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.google.common.collect.Maps;

@Service
public class ChaincodeService {
    @Autowired
    private Client client;

    public Map<String, Object> hello() throws GatewayException,Exception {
        Contract contract=client.contract();
        Map<String, Object> result = Maps.newConcurrentMap();
        byte[] res = contract.evaluateTransaction("hello");
        result.put("payload", StringUtils.newStringUtf8(res));
        result.put("status", "ok");
        return result;
    }

    public Map<String, Object> getHello() throws GatewayException,Exception {
        Contract contract=client.contract();
        Map<String, Object> result = Maps.newConcurrentMap();
        byte[] res = contract.evaluateTransaction("getHello");
        result.put("payload", StringUtils.newStringUtf8(res));
        return result;
    }


    public Map<String, Object> queryAccount() throws GatewayException,Exception {
        Contract contract=client.contract();
        Map<String, Object> result = Maps.newConcurrentMap();
        byte[] res = contract.evaluateTransaction("queryAccount");
        result.put("payload", StringUtils.newStringUtf8(res));
        result.put("status", "ok");
        return result;
    }
}
