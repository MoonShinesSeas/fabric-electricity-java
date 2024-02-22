package com.fabric.controller;

import com.fabric.service.SellingService;
import org.hyperledger.fabric.gateway.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.concurrent.TimeoutException;

@RestController
@RequestMapping("/selling")
public class SellingController {
    @Autowired
    private SellingService sellingService;

    @GetMapping("querySellingList")
    public Map<String, Object> querySellingList() throws GatewayException, Exception {
        return sellingService.querySellingList();
    }

    @PostMapping("querySellingByBuyer")
    public Map<String, Object> querySellingByBuyer(@RequestParam("buyer") String buyer)
            throws GatewayException, TimeoutException, InterruptedException, Exception {
        return sellingService.querySellingByBuyer(buyer);
    }

    @PostMapping("createSelling")
    @ResponseBody
    public Map<String, Object> createSelling(@RequestParam("electricityID") String electricityID,
            @RequestParam("seller") String seller,
            @RequestParam("price") String price,
            @RequestParam("saleperiod") String saleperiod)
            throws GatewayException, TimeoutException, InterruptedException, Exception {
        return sellingService.createSelling(electricityID, seller, price, saleperiod);
    }

    @PostMapping("buy")
    @ResponseBody
    public Map<String, Object> buy(@RequestParam("electricityID") String electricityID,
            @RequestParam("seller") String seller,
            @RequestParam("buyer") String buyer)
            throws GatewayException, TimeoutException, InterruptedException, Exception {
        return sellingService.buy(electricityID, seller, buyer);
    }

    @PostMapping("updateSelling")
    @ResponseBody
    public Map<String, Object> updateSelling(@RequestParam("electricityID") String electricityID,
            @RequestParam("seller") String seller,
            @RequestParam("buyer") String buyer,
            @RequestParam("status") String status)
            throws GatewayException, TimeoutException, InterruptedException, ContractException, Exception {
        return sellingService.updateSelling(electricityID, seller, buyer, status);
    }

    @PostMapping("queryHistory")
    @ResponseBody
    public Map<String, Object> queryHistory(@RequestParam("marblename") String marblename)
            throws GatewayException, TimeoutException, InterruptedException,Exception {
        return sellingService.queryHistory(marblename);
    }
}
