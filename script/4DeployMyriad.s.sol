// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Myriad} from "../src/core/Myriad.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract DeployMyriad is Script {
    // address governanceTokenAddress = DevOpsTools.get_most_recent_deployment("GovernanceToken", block.chainid);
    address governanceTokenAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3;

    function run() external returns (address) {
        address proxy = deployMyriad();
        return proxy;
    }

    function deployMyriad() internal returns (address) {
        vm.startBroadcast();
        Myriad myriad = new Myriad(); //Our implementation(logic). Proxy will point here to delegate call/borrow the functions
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(myriad),
            abi.encodeWithSignature("initialize(address)", governanceTokenAddress) // initialize the logic contract
        );
        vm.stopBroadcast();
        return address(proxy);
    }
}
