// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/KYCToken.sol";
import {MockKYCToken} from "./mocks/MockKYCToken.sol";

contract KYCTokenTest is Test {
    KYCToken public token;

    function setUp() public {
        token = new KYCToken();
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
        vm.deal(customer, 1 ether);
        vm.prank(customer);
        token.mint(customer, 100);
    }

    function testMintOnValidKYC(address customer, string memory customerName)
        public
    {
        vm.assume(bytes(customerName).length > 0);
        vm.deal(customer, 1 ether);
        vm.startPrank(customer); // Run test from given 'customer' address
        token.kyc(customerName);
        token.mint(customer, 100);
        vm.stopPrank();
    }

    function testFailMintIfNotAccredited(address customer, uint256 amount)
        public
    {
        vm.assume(amount < 1 ether);
        vm.deal(customer, amount);

        vm.startPrank(customer);
        token.kyc("Random name");
        token.mint(customer, 100);
        vm.stopPrank();
    }

    function testMintIfAccredited(address customer, uint256 amount) public {
        vm.assume(amount >= 1 ether);
        vm.deal(customer, amount);

        vm.startPrank(customer);
        token.kyc("Random name");
        token.mint(customer, 100);
        vm.stopPrank();
    }
}
