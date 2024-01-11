// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Myriad} from "../src/core/Myriad.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployMyriad is Script {
    function run() external returns (address) {
        address proxy = deployMyriad();
        return proxy;
    }

    function deployMyriad() public returns (address) {
        vm.startBroadcast();
        Myriad myriad = new Myriad(); //Our implementation(logic).Proxy will point here to delegate call/borrow the functions
        ERC1967Proxy proxy = new ERC1967Proxy(address(myriad), "");
        vm.stopBroadcast();
        return address(proxy);
    }
}
