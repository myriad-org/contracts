// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Myriad} from "../src/core/Myriad.sol";
import {GovernanceToken} from "../src/governance/GovernanceToken.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployGovernanceToken is Script {
    function run() external returns (address) {
        vm.startBroadcast();
        GovernanceToken governanceToken = new GovernanceToken(msg.sender, msg.sender, address(0));
        vm.stopBroadcast();
        return address(governanceToken);
    }

    function deployMyriad() internal returns (address) {}
}
