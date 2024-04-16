// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Myriad} from "src/core/Myriad.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {DataTypes} from "../src/libraries/DataTypes.sol";
import {GovernanceToken} from "../src/governance/GovernanceToken.sol";

contract AddLabDetails is Script {
    function run() external {
        address proxyAddress = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        address governanceTokenAddress = DevOpsTools.get_most_recent_deployment("GovernanceToken", block.chainid);

        vm.startBroadcast();
        Myriad proxy = Myriad(payable(proxyAddress));

        proxy.addDiagnosticLabDetails(
            GovernanceToken(governanceTokenAddress),
            0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc,
            "test-lab",
            "lab1",
            "lab1@lab1.com",
            "9191919191"
        );
        vm.stopBroadcast();
    }
}
