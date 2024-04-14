// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Myriad} from "../src/core/Myriad.sol";
import {Timelock} from "../src/governance/Timelock.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployTimelock is Script {
    function run() external returns (address) {
        vm.startBroadcast();

        address[] memory toall = new address[](1);
        address[] memory admin = new address[](1);
        toall[0] = address(0);
        admin[0] = msg.sender;

        Timelock timelock = new Timelock(10, toall, toall, admin);
        vm.stopBroadcast();
        return address(timelock);
    }

    function deployMyriad() internal returns (address) {}
}
