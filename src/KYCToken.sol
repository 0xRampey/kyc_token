// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract KYCToken is ERC20 {
    mapping(address => string) private knownCustomers;

    constructor() ERC20("KYC Token", "KYC", 18) {} // TODO: how many decimals?

    function kyc(string calldata name) public {
        // Make sure 'name' is not empty
        require(!isEmpty(name));
        knownCustomers[msg.sender] = name;
    }

    modifier checkKYC() {
        require(!isEmpty(knownCustomers[msg.sender]));
        _;
    }

    modifier checkAccredited() {
        require(msg.sender.balance >= 1 ether);
        _;
    }

    function isEmpty(string memory value) internal pure returns (bool) {
        return bytes(value).length == 0;
    }

    function _mint(address to, uint256 amount)
        internal
        override
        checkKYC
        checkAccredited
    {
        totalSupply += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal override checkKYC {
        balanceOf[from] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}
