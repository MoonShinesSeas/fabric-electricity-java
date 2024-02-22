/*
SPDX-License-Identifier: Apache-2.0
*/

package com.fabric.service;

import java.nio.file.Paths;
import java.util.Properties;

import org.hyperledger.fabric.gateway.Wallet;
import org.hyperledger.fabric.gateway.Wallets;
import org.hyperledger.fabric.gateway.Identities;
import org.hyperledger.fabric.gateway.Identity;
import org.hyperledger.fabric.sdk.Enrollment;
import org.hyperledger.fabric.sdk.security.CryptoSuite;
import org.hyperledger.fabric.sdk.security.CryptoSuiteFactory;
import org.hyperledger.fabric_ca.sdk.EnrollmentRequest;
import org.hyperledger.fabric_ca.sdk.HFCAClient;
import org.springframework.stereotype.Service;

@Service
public class EnrollAdmin {

	static {
		System.setProperty("org.hyperledger.fabric.sdk.service_discovery.as_192.168.208.129", "true");
	}

	public String enroll() throws Exception {

		// Create a CA client for interacting with the CA.
		Properties props = new Properties();
		props.put("pemFile",
			"../network/crypto-config/peerOrganizations/taobao.com/ca/ca.taobao.com-cert.pem");
		props.put("allowAllHostNames", "true");
		HFCAClient caClient = HFCAClient.createNewInstance("http://192.168.208.129:8054", props);
		CryptoSuite cryptoSuite = CryptoSuiteFactory.getDefault().getCryptoSuite();
		caClient.setCryptoSuite(cryptoSuite);

		// Create a wallet for managing identities
		Wallet wallet = Wallets.newFileSystemWallet(Paths.get("application","src/main/resources/wallet"));

		// Check to see if we've already enrolled the admin user.
		if (wallet.get("tb-ca-admin") != null) {
			System.out.println("An identity for the admin user \"admin\" already exists in the wallet");
			return "An identity for the admin user \"admin\" already exists in the wallet";
		}

		// Enroll the admin user, and import the new identity into the wallet.
		final EnrollmentRequest enrollmentRequestTLS = new EnrollmentRequest();
		enrollmentRequestTLS.addHost("192.168.208.129");
		enrollmentRequestTLS.setProfile("tls");
		Enrollment enrollment = caClient.enroll("tb-ca-admin", "tb-ca-adminpw", enrollmentRequestTLS);
		Identity user = Identities.newX509Identity("TaobaoMSP", enrollment);
		wallet.put("tb-ca-admin", user);
		System.out.println("Successfully enrolled user \"admin\" and imported it into the wallet");
		return "Successfully enrolled user \"admin\" and imported it into the wallet";
	}
}
