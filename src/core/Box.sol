// contracts/Box.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Box is Ownable {
    int256 private value;

    constructor() Ownable(msg.sender) {
        value = -1;
    }

    // Emitted when the stored value changes
    event ValueChanged(int256 newValue);

    // Stores a new value in the contract
    function store(int256 newValue) public {
        value = newValue;
        emit ValueChanged(newValue);
    }

    // Stores a new value in the contract
    function storeOwner(int256 newValue) public onlyOwner{
        value = newValue;
        emit ValueChanged(newValue);
    }


    // Reads the last stored value
    function retrieve() public view returns (int256) {
        return value;
    }

    fallback() external payable {}
    receive() external payable {}
}