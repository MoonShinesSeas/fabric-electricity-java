package com.fabric.service;

import org.hyperledger.fabric.gateway.Gateway;
import org.hyperledger.fabric.gateway.Network;
import java.util.Collection;
import org.hyperledger.fabric.sdk.Channel;
import org.hyperledger.fabric.sdk.Peer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ChannelService {
    @Autowired
    private Client client;

    public void getChannel() throws Exception {
        Gateway gateway = client.gateway();
        // Get the channel
        Network network = gateway.getNetwork("appchannel");
        Channel channel = network.getChannel();

        // Get the list of peers that joined the channel
        Collection<Peer> peers = channel.getPeers();

        System.out.println(peers);
    }
    
}