// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Myriad} from "src/core/Myriad.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {DataTypes} from "../src/libraries/DataTypes.sol";

contract Custom is Script {
    function run() external {
        address proxyAddress = DevOpsTools.get_most_recent_deployment(
            "ERC1967Proxy",
            block.chainid
        );

        vm.startBroadcast();
        Myriad proxy = Myriad(payable(proxyAddress));
        console.log("msg.sender: ", msg.sender);
        console.log("Owner: ", proxy.owner());
        console.log("Implementation contract Version: ", proxy.version());
        console.log("Implementation: ", proxy.getImplementation());

        string memory name;
        string memory publicKey;
        uint256 dateOfRegistration;
        (name, publicKey, dateOfRegistration) = proxy.getPatientDetails(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8
        );
        console.log("Patient name: ", name);
        console.log("Patient dateOfRegistration: ", dateOfRegistration);

        vm.stopBroadcast();
    }

    function upgradeMyriad(
        address proxyAddress,
        address newMyriad
    ) internal returns (address) {
        vm.startBroadcast();
        Myriad proxy = Myriad(payable(proxyAddress));
        proxy.upgradeToAndCall(address(newMyriad), bytes(""));
        vm.stopBroadcast();
        return address(proxy);
    }
}
