package com.fabric.controller;

import java.util.Map;
import java.util.concurrent.TimeoutException;

import org.hyperledger.fabric.gateway.GatewayException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.fabric.service.ElectricityService;

@RestController
@RequestMapping("/electricity")
public class ElectricityController {
    @Autowired
    private ElectricityService electricityService;

    @PostMapping("createElectricity")
    @ResponseBody
    public Map<String, Object> createElectricity(@RequestParam("owner") String owner,
            @RequestParam("manufacturers") String manufacturers,
            @RequestParam("quantity") String quantity,
            @RequestParam("time") String time)
            throws GatewayException, InterruptedException, TimeoutException, Exception {
        return electricityService.createElectricity(owner, manufacturers, quantity, time);
    }

    @PostMapping("queryElectricity")
    @ResponseBody
    public Map<String, Object> queryElectricity(@RequestParam("owner") String owner)
            throws GatewayException, Exception {
        return electricityService.queryElectricity(owner);
    }

}
