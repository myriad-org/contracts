// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Myriad} from "src/core/Myriad.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {DataTypes} from "../src/libraries/DataTypes.sol";

contract Custom is Script {
    function run() external {
        address proxyAddress = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        Myriad proxy = Myriad(payable(proxyAddress));

        console.log("\n----- System Details -----");
        console.log("msg.sender: ", msg.sender);
        console.log("Core contract owner: ", proxy.owner());
        console.log("Implementation contract Version: ", proxy.version());
        console.log("Implementation Address: ", proxy.getImplementation());

        string memory name;
        string memory publicKey;
        uint256 dateOfRegistration;
        address hospitalAddress;
        string memory registrationId;
        string memory email;

        // Patient Details
        console.log("\n------System Patient Details-------");
        (name, publicKey, dateOfRegistration) = proxy.getPatientDetails(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        console.log("Patient name: ", name);
        console.log("Patient dateOfRegistration: ", dateOfRegistration);

        // Doctor Details
        console.log("\n------System Doctor Details-------");
        (name, publicKey, registrationId, hospitalAddress) =
            proxy.getDoctorDetails(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        console.log("Doctor name: ", name);
        console.log("Doctor registrationId: ", registrationId);
        console.log("Doctor Specialization: ", publicKey); // publicKey is specialization (reuse var)
        console.log("Doctor hospitalAddress: ", hospitalAddress);

        // Hospital Details
        console.log("\n------System Hospital Details-------");
        (name, registrationId, email) = proxy.getHospitalDetails(0x90F79bf6EB2c4f870365E785982E1f101E93b906);
        console.log("Hospital name: ", name);
        console.log("Hospital registrationId: ", registrationId);
        console.log("Hospital email: ", email);

        // Clinic Details
        console.log("\n------System Clinic Details-------");
        (name, registrationId, email) = proxy.getClinicDetails(0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65);
        console.log("Clinic name: ", name);
        console.log("Clinic registrationId: ", registrationId);
        console.log("Clinic email: ", email);

        // Lab Details
        console.log("\n------System Lab Details-------");
        (name, registrationId, email) = proxy.getDiagnosticLabDetails(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc);
        console.log("Lab name: ", name);
        console.log("Lab registrationId: ", registrationId);
        console.log("Lab email: ", email);

        vm.stopBroadcast();
    }

    function upgradeMyriad(address proxyAddress, address newMyriad) internal returns (address) {
        vm.startBroadcast();
        Myriad proxy = Myriad(payable(proxyAddress));
        proxy.upgradeToAndCall(address(newMyriad), bytes(""));
        vm.stopBroadcast();
        return address(proxy);
    }
}
