// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/KYCToken.sol";
import {MockKYCToken} from "./mocks/MockKYCToken.sol";

contract KYCTokenTest is Test {
    MockKYCToken public token;

    function setUp() public {
        token = new MockKYCToken();
    }

    function testFailKYCOnEmptyName() public {
        token.kyc("");
    }

    function testKYC(address random, string memory name) public {
        vm.assume(bytes(name).length > 0);
        vm.prank(random);
        token.kyc(name);
    }

    function testFailMintOnNonKYC(address customer) public {
        vm.prank(customer);
        token.mint(customer, 100);
    }

    function testMintOnValidKYC(address customer, string memory customerName)
        public
    {
        vm.assume(bytes(customerName).length > 0);
        vm.startPrank(customer); // Run test from given 'customer' address
        token.kyc(customerName);
        token.mint(customer, 100);
        vm.stopPrank();
    }
}
