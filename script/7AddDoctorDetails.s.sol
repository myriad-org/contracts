// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Myriad} from "src/core/Myriad.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {DataTypes} from "../src/libraries/DataTypes.sol";
import {GovernanceToken} from "../src/governance/GovernanceToken.sol";

contract AddDoctorDetails is Script {
    function run() external {
        address proxyAddress = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        address governanceTokenAddress = DevOpsTools.get_most_recent_deployment("GovernanceToken", block.chainid);

        vm.startBroadcast();
        Myriad proxy = Myriad(payable(proxyAddress));

        proxy.addDoctorDetails(
            GovernanceToken(governanceTokenAddress),
            0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC,
            "test-doctor",
            "doc1",
            "test-specialization",
            0x90F79bf6EB2c4f870365E785982E1f101E93b906
        );
        vm.stopBroadcast();
    }
}
