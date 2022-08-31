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

    function mint(address to, uint256 amount)
        external
        checkKYC
        checkAccredited
    {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount)
        external
        checkKYC
        checkAccredited
    {
        _burn(from, amount);
    }
}
