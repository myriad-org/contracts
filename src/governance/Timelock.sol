// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.20;

import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";

contract Timelock is TimelockController {
    constructor(uint256 minDelay, address[] memory proposers, address[] memory executors, address[] memory admins)
        TimelockController(minDelay, proposers, executors, msg.sender)
    {}
}
