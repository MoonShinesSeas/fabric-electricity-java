package com.fabric.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fabric.service.ChannelService;
import org.springframework.web.bind.annotation.GetMapping;


@RestController
@RequestMapping("/channel")
public class ChannelController {
    @Autowired
    private ChannelService channelService;

    @GetMapping("getChannel")
    public void getChannel()throws Exception {
        channelService.getChannel();
    }
    
}
