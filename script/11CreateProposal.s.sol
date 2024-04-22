// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Myriad} from "src/core/Myriad.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {DataTypes} from "../src/libraries/DataTypes.sol";
import {GovernanceToken} from "../src/governance/GovernanceToken.sol";
import {GovernorContract} from "../src/governance/GovernorContract.sol";

contract CreateProposal is Script {
    uint256 public constant VOTING_DELAY = 2; // how many blocks the proposal is active
    uint256 public constant VOTING_PERIOD = 25; // how many seconds the proposal is active
    uint8 public constant valueToStore = 55;
    string reason = "cuz blue frog is cool";
    uint8 voteWay = 1; // voting yes
    uint256 proposalId;

    // This creates proposal and rolls the block to the voting period and
    // makes proposal state to active
    function run() external {
        address myriadProxyAddress = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        address governorContractAddress = DevOpsTools.get_most_recent_deployment("GovernorContract", block.chainid);

        GovernorContract governor = GovernorContract(payable(governorContractAddress));

        vm.startBroadcast();

        console.log("\n----- Create Proposal -----");

        address[] memory targets = new address[](1);
        uint256[] memory values = new uint256[](1);
        bytes[] memory calldatas = new bytes[](1);
        string memory description;

        targets[0] = myriadProxyAddress;
        values[0] = 0;
        calldatas[0] = abi.encodeWithSignature("store(uint256)", valueToStore);

        proposalId = governor.propose(targets, values, calldatas, description);
        console.log("Proposal ID: %d", proposalId);
        console.log("Proposal State: ", uint8(governor.state(proposalId)));

        vm.warp(block.timestamp + VOTING_DELAY + 1);
        vm.roll(block.timestamp + VOTING_DELAY + 1);

        console.log("1Proposal State: ", uint256(governor.state(proposalId)));

        // Voting on Proposal
        console.log("-----Voting on Proposal -----");
        console.log("2Proposal State: ", uint8(governor.state(proposalId)));
        uint256 weight = governor.castVoteWithReason(proposalId, voteWay, reason);
        console.log("3Vote Weight: ", weight);
        // console.log("Proposal State: ", uint8(governor.state(proposalId)));
        console.log("4Voted successfully");

        vm.warp(block.timestamp + VOTING_PERIOD + 1);
        vm.roll(block.number + VOTING_PERIOD + 1);

        console.log("5Proposal State: ", uint8(governor.state(proposalId)));
        vm.stopBroadcast();
    }
}
