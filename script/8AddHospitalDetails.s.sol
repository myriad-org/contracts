// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Myriad} from "src/core/Myriad.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {DataTypes} from "../src/libraries/DataTypes.sol";
import {GovernanceToken} from "../src/governance/GovernanceToken.sol";

contract AddHospitalDetails is Script {
    function run() external {
        address proxyAddress = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        address governanceTokenAddress = DevOpsTools.get_most_recent_deployment("GovernanceToken", block.chainid);

        vm.startBroadcast();
        Myriad proxy = Myriad(payable(proxyAddress));

        proxy.addHospitalDetails(
            GovernanceToken(governanceTokenAddress),
            0x90F79bf6EB2c4f870365E785982E1f101E93b906,
            "test-hospital",
            "hos1",
            "hos1@hos1.com",
            "9898989898"
        );
        vm.stopBroadcast();
    }
}
