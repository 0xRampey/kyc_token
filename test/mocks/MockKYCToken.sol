// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {KYCToken} from "../../src/KYCToken.sol";

contract MockKYCToken is KYCToken {
    mapping(address => string) private kycDB;

    constructor() KYCToken() {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public {
        _burn(from, amount);
    }
}
