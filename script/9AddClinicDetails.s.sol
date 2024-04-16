// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Myriad} from "src/core/Myriad.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {DataTypes} from "../src/libraries/DataTypes.sol";
import {GovernanceToken} from "../src/governance/GovernanceToken.sol";

contract AddClinicDetails is Script {
    function run() external {
        address proxyAddress = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        address governanceTokenAddress = DevOpsTools.get_most_recent_deployment("GovernanceToken", block.chainid);

        vm.startBroadcast();
        Myriad proxy = Myriad(payable(proxyAddress));

        proxy.addClinicDetails(
            GovernanceToken(governanceTokenAddress),
            0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65,
            "test-clinic",
            "clnc1",
            "clnc1@clnc1.com",
            "8989898989"
        );
        vm.stopBroadcast();
    }
}
