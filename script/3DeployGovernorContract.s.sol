// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {GovernorContract} from "../src/governance/GovernorContract.sol";
import {GovernanceToken} from "../src/governance/GovernanceToken.sol";
import {Timelock} from "../src/governance/Timelock.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract DeployGovernorContract is Script {
    function run() external returns (address) {
        vm.startBroadcast();
        address governanceTokenAddress = DevOpsTools.get_most_recent_deployment("GovernanceToken", block.chainid);

        address timelockAddress = DevOpsTools.get_most_recent_deployment("Timelock", block.chainid);

        GovernorContract governorContract =
            new GovernorContract(GovernanceToken(payable(governanceTokenAddress)), Timelock(payable(timelockAddress))); //Our implementation(logic). Proxy will point here to delegate call/borrow the functions
        vm.stopBroadcast();
        return address(governorContract);
    }
}
