package com.fabric.service;

import java.nio.file.Path;
import java.nio.file.Paths;

import org.hyperledger.fabric.gateway.Contract;
import org.hyperledger.fabric.gateway.Gateway;
import org.hyperledger.fabric.gateway.Network;
import org.hyperledger.fabric.gateway.Wallet;
import org.hyperledger.fabric.gateway.Wallets;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Client {
    static {
        System.setProperty("org.hyperledger.fabric.sdk.service_discovery.as_192.168.208.129", "true");
    }

    public Gateway gateway() throws Exception {
        // Load a file system based wallet for managing identities.
        Path walletPath = Paths.get("application", "src/main/resources/wallet");
        Wallet wallet = Wallets.newFileSystemWallet(walletPath);
        // load a CCP
        Path networkConfigPath = Paths.get("application", "src/main/resources/connection.json");
        // C:\Users\28495\Desktop\java\application\src\main\resources\fabric.config.properties
        Gateway.Builder builder = Gateway.createBuilder()
                .identity(wallet, "appUser")
                .networkConfig(networkConfigPath);
        Gateway gateway = builder.connect();
        return gateway;
    }

    public Network network() throws Exception {
        Gateway gateway = gateway();
        Network network = gateway.getNetwork("appchannel");
        return network;
    }

    public Contract contract() throws Exception {
        Network network = network();
        Contract contract = network.getContract("chaincode-go_1");
        return contract;
    }
}
