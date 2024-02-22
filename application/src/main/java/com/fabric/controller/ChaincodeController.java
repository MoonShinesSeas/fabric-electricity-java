package com.fabric.controller;

import org.springframework.web.bind.annotation.RestController;

import com.fabric.service.ChaincodeService;
import java.util.Map;

import org.hyperledger.fabric.gateway.GatewayException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
@RequestMapping("/chaincode")
public class ChaincodeController {
    @Autowired
    private ChaincodeService chaincodeService;

    @GetMapping("hello")
    public Map<String, Object> hello() throws GatewayException, Exception {
        return chaincodeService.hello();
    }

    @GetMapping("gethello")
    public Map<String, Object> getHello() throws GatewayException, Exception {
        return chaincodeService.getHello();
    }

    @GetMapping("queryAccount")
    public Map<String, Object> queryAccount() throws GatewayException, Exception {
        return chaincodeService.queryAccount();
    }
}
