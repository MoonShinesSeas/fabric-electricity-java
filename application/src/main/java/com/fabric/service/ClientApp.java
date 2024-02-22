package com.fabric.service;

import java.nio.file.Path;
import java.nio.file.Paths;

import org.hyperledger.fabric.gateway.Contract;
import org.hyperledger.fabric.gateway.Gateway;
import org.hyperledger.fabric.gateway.Network;
import org.hyperledger.fabric.gateway.Wallet;
import org.hyperledger.fabric.gateway.Wallets;
import org.springframework.stereotype.Service;

@Service
public class ClientApp {
    static {
        System.setProperty("org.hyperledger.fabric.sdk.service_discovery.as_192.168.208.129", "true");
    }

    public String proxy() throws Exception {
        // Load a file system based wallet for managing identities.
        Path walletPath = Paths.get("application","src/main/resources/wallet");
        Wallet wallet = Wallets.newFileSystemWallet(walletPath);
        // load a CCP
        Path networkConfigPath = Paths.get("application","src/main/resources/connection.json");
        // C:\Users\28495\Desktop\java\application\src\main\resources\fabric.config.properties
        Gateway.Builder builder = Gateway.createBuilder();
        builder.identity(wallet, "appUser").networkConfig(networkConfigPath);

        // create a gateway connection
        try (Gateway gateway = builder.connect()) {

            // get the network and contract
            Network network = gateway.getNetwork("appchannel");
            Contract contract = network.getContract("chaincode-go_1");

            byte[] result;

            result = contract.evaluateTransaction("hello");
            System.out.println(new String(result));
            byte[] result1;
            result1 = contract.submitTransaction("createElectricity", "d4735e3a265e","zm","257","2024-2-20");
            System.out.println(new String(result1));
            return new String(result);
        }
    }
}
