// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {KYCToken} from "../../src/KYCToken.sol";

contract MockKYCToken is KYCToken {
    mapping(address => string) private kycDB;

    constructor() KYCToken() {}
}
