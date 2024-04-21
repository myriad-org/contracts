// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Myriad} from "src/core/Myriad.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {DataTypes} from "../src/libraries/DataTypes.sol";
import {GovernanceToken} from "../src/governance/GovernanceToken.sol";
import {GovernorContract} from "../src/governance/GovernorContract.sol";

contract VoteProposal is Script {
    uint256 public constant VOTING_DELAY = 2; // how many blocks the proposal is active
    uint256 public constant VOTING_PERIOD = 25; // how many seconds the proposal is active
    string reason = "cuz blue frog is cool";
    uint8 voteWay = 1; // voting yes
    uint256 proposalId =
        113413527849118946908170876607229112009022536516111042163250246188940866726140;

    // This creates proposal and rolls the block to the voting period and
    // makes proposal state to active
    function run() external {
        address governorContractAddress = DevOpsTools
            .get_most_recent_deployment("GovernorContract", block.chainid);

        GovernorContract governor = GovernorContract(
            payable(governorContractAddress)
        );

        console.log("\n----- Vote on Proposal -----");
        vm.startBroadcast();

        console.log("1Proposal State: ", uint8(governor.state(proposalId)));
        vm.warp(block.timestamp + VOTING_DELAY + 1);
        vm.roll(block.timestamp + VOTING_DELAY + 1);

        console.log("2Proposal State: ", uint8(governor.state(proposalId)));
        uint256 weight = governor.castVoteWithReason(
            proposalId,
            voteWay,
            reason
        );
        console.log("3Vote Weight: ", weight);
        // console.log("Proposal State: ", uint8(governor.state(proposalId)));
        console.log("4Voted successfully");

        vm.warp(block.timestamp + VOTING_PERIOD + 1);
        vm.roll(block.number + VOTING_PERIOD + 1);

        console.log("5Proposal State: ", uint8(governor.state(proposalId)));

        vm.stopBroadcast();
    }
}
