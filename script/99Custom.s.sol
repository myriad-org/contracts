// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Myriad} from "src/core/Myriad.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {DataTypes} from "../src/libraries/DataTypes.sol";
import {GovernanceToken} from "../src/governance/GovernanceToken.sol";

contract Custom is Script {
    function run() external {
        address proxyAddress = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
        address governanceTokenAddress = DevOpsTools.get_most_recent_deployment("GovernanceToken", block.chainid);

        vm.startBroadcast();
        Myriad proxy = Myriad(payable(proxyAddress));

        console.log("\n----- System Details -----");
        console.log("msg.sender: ", msg.sender);
        console.log("Core contract owner: ", proxy.owner());
        console.log("Implementation contract Version: ", proxy.version());
        console.log("Implementation Address: ", proxy.getImplementation());

        // address actorAddress;
        // string memory actorInfo;
        // bool isValid;
        // string memory publicKey;
        // uint256 dateOfRegistration;
        // address hospitalAddress;
        // string memory registrationId;
        // string memory email;

        // // Patient Details
        // console.log("\n------System Patient Details-------");
        // (actorAddress, actorInfo, isValid) = proxy.getPatientDetails(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        // console.log("Patient Address: ", actorAddress);
        // console.log("Patient Info: ", actorInfo);
        // console.log("Patient isValid: ", isValid);

        // // Doctor Details
        // console.log("\n------System Doctor Details-------");
        // (actorAddress, actorInfo, isValid) = proxy.getDoctorDetails(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        // console.log("Doctor Address: ", actorAddress);
        // console.log("Doctor Info: ", actorInfo);
        // console.log("Doctor publicKey: ", isValid);

        // // Hospital Details
        // console.log("\n------System Hospital Details-------");
        // (actorAddress, actorInfo, isValid) = proxy.getHospitalDetails(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        // console.log("Hospital Address: ", actorAddress);
        // console.log("Hospital Info: ", actorInfo);
        // console.log("Hospital isValid: ", isValid);

        // // Clinic Details
        // console.log("\n------System Clinic Details-------");
        // (actorAddress, actorInfo, isValid) = proxy.getClinicDetails(0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65);
        // console.log("Clinic Address: ", actorAddress);
        // console.log("Clinic Info: ", actorInfo);
        // console.log("Clinic isValid: ", isValid);

        // // Lab Details
        // console.log("\n------System Lab Details-------");
        // (actorAddress, actorInfo, isValid) = proxy.getDiagnosticLabDetails(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc);
        // console.log("Lab Address: ", actorAddress);
        // console.log("Lab Info: ", actorInfo);
        // console.log("Lab isValid: ", isValid);

        // Token Details
        console.log("\n------System Token Details-------");
        GovernanceToken governanceToken = GovernanceToken(payable(governanceTokenAddress));
        uint256 totalSupply = governanceToken.totalSupply();
        console.log("Total Supply: ", totalSupply);
        uint256 votes = governanceToken.getVotes(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        console.log("Votes for registered patient: ", votes);

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
