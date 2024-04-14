// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Myriad} from "src/core/Myriad.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {DataTypes} from "../src/libraries/DataTypes.sol";

contract RegisterPatient is Script {
    function run() external {
        address proxyAddress = DevOpsTools.get_most_recent_deployment(
            "ERC1967Proxy",
            block.chainid
        );

        vm.startBroadcast();
        Myriad proxy = Myriad(payable(proxyAddress));
        
        proxy.registerPatient(0x70997970C51812dc3A010C7d01b50e0d17dc79C8, "test-name", 12131314, "8989898989", "O+", "test-public-key");
        vm.stopBroadcast();
    }
}
