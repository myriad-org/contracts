// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Myriad} from "src/core/Myriad.sol";
import {Myriad as MyriadV2} from "src/core/Myriad.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract UpgradeMyriad is Script {
    function run() external returns (address) {
        address mostRecentlyDeployedProxy = DevOpsTools
            .get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        MyriadV2 myriadv2 = new MyriadV2();
        vm.stopBroadcast();
        address proxy = upgradeMyriad(
            mostRecentlyDeployedProxy,
            address(myriadv2)
        );
        return proxy;
    }

    function upgradeMyriad(
        address proxyAddress,
        address newMyriad
    ) internal returns (address) {
        vm.startBroadcast();
        Myriad proxy = Myriad(payable(proxyAddress));
        proxy.upgradeToAndCall(address(newMyriad), "");
        vm.stopBroadcast();
        return address(proxy);
    }
}
