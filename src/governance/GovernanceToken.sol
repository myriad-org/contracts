// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

/// @custom:security-contact sadityakumar9211@gmail.com
contract GovernanceToken is ERC20, ERC20Burnable, Ownable, ERC20Permit, ERC20Votes {
    constructor(address initialOwner)
        ERC20("Myriad Token", "MYT")
        Ownable(initialOwner)
        ERC20Permit("Myriad Token")
    {}

    // Can only be called by Myriad Contract - (It's proxy)
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function delegate(address from, address to) public {
        _delegate(from, to);
    }

    function decimals() public pure override returns(uint8) {
        return 0;
    }

    // The following functions are overrides required by Solidity.
    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Votes)
    {
        super._update(from, to, value);
    }

    function nonces(address owner)
        public
        view
        override(ERC20Permit, Nonces)
        returns (uint256)
    {
        return super.nonces(owner);
    }
}