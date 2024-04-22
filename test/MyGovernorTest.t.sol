// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {GovernorContract} from "../src/governance/GovernorContract.sol";
import {Myriad} from "../src/core/Myriad.sol";
import {Timelock} from "../src/governance/Timelock.sol";
import {GovernanceToken} from "../src/governance/GovernanceToken.sol";

contract GovernorContractTest is Test {
    GovernorContract governor;
    Myriad myraid;
    Timelock timelock;
    GovernanceToken govToken;

    address public USER = makeAddr("user");
    uint8 public constant INITIAL_SUPPLY = 100;

    uint256 public constant MIN_DELAY = 3600;
    uint256 public constant VOTING_DELAY = 1; // how many blocks the proposal is active
    uint256 public constant VOTING_PERIOD = 50400; // how many blocks the proposal is active

    address[] proposers;
    address[] executors;
    address[] admins = [USER];

    uint256[] values = [0];
    bytes[] calldatas;
    address[] targets;

    function setUp() public {
        govToken = new GovernanceToken(msg.sender);
        govToken.mint(USER, INITIAL_SUPPLY);
        vm.startPrank(USER);
        govToken.delegate(USER);
        timelock = new Timelock(MIN_DELAY, proposers, executors, admins);
        governor = new GovernorContract(govToken, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.DEFAULT_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor));
        timelock.grantRole(executorRole, address(0));
        timelock.revokeRole(adminRole, USER);
        vm.stopPrank();

        myraid = new Myriad();
        myraid.transferOwnership(address(timelock));
    }

    function testCantUpdateBoxWithoutGovernance() public {
        vm.expectRevert();
    }

    function testGovernanceUpdateBox() public {
        uint256 valueToStore = 111;
        string memory description = "store 111 in Myriad";
        bytes memory encodedFunctionCall = abi.encodeWithSignature("store(uint256)", valueToStore);
        calldatas.push(encodedFunctionCall);
        targets.push(address(myraid));

        // 1. Propose to the DAO
        uint256 proposalId = governor.propose(targets, values, calldatas, description);

        // View the state
        console.log("Proposal State: ", uint256(governor.state(proposalId)));

        vm.warp(block.timestamp + VOTING_DELAY + 1);
        vm.roll(block.number + VOTING_DELAY + 1);

        console.log("Proposal State: ", uint256(governor.state(proposalId)));

        // 2. Vote
        string memory reason = "cuz blue frog is cool";
        uint8 voteWay = 1; // voting yes

        vm.prank(USER);
        governor.castVoteWithReason(proposalId, voteWay, reason);
        vm.stopPrank();

        vm.warp(block.timestamp + VOTING_PERIOD + 1);
        vm.roll(block.number + VOTING_PERIOD + 1);

        // 3. Queue
        bytes32 descriptionHash = keccak256(abi.encodePacked(description));
        governor.queue(targets, values, calldatas, descriptionHash);

        vm.warp(block.timestamp + MIN_DELAY + 1);
        vm.roll(block.number + MIN_DELAY + 1);

        // 4. Execute
        governor.execute(targets, values, calldatas, descriptionHash);

        // // 5. Check if the value is updated
        // uint256 storedValue = myraid.getNumber();
        // assertEq(storedValue, valueToStore);
        // console.log("Stored Values changed to ", storedValue);
        // console.log("Proposal State", uint256(governor.state(proposalId)));
    }
}
