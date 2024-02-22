package com.fabric.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.fabric.service.ClientApp;
import com.fabric.service.EnrollAdmin;
import com.fabric.service.RegisterUser;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("fabric_ca")
public class CAController {
    @Autowired
    private EnrollAdmin enrollAdmin;

    @Autowired
    private RegisterUser registerUser;

    @Autowired
    private ClientApp clientApp;

    @GetMapping("/enrollAdmin")
    @ResponseBody
    public String enroll() throws Exception {
        return enrollAdmin.enroll();
    }

    @PostMapping("/registerUser")
    @ResponseBody
    public String register(@RequestParam String username) throws Exception {
        // TODO: process POST request
        return registerUser.register(username);
    }

    @GetMapping("/proxy")
    @ResponseBody
    public String proxy() throws Exception {
        return clientApp.proxy();
    }

}
